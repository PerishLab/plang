# Await lowering slice

`seed/await.pir` is the first executable lowering target for default await. It
adds three fixed-capacity objects to the bounded channel state machine:

```text
scheduler = runnable task FIFO
channel   = value FIFO + reader waiter FIFO + terminal state
task      = resume func + program counter + scheduler + channel + target + done
```

All three objects allocate their complete storage at construction. Enqueue,
wait, wake, resume, close, and fail allocate nothing. The scheduler is
single-threaded and FIFO.

A resumable consumer first polls `channel_recv`. On `pending`, it registers its
task in the channel's waiter FIFO and returns to the scheduler; it is not placed
back on the runnable queue and therefore cannot busy-poll. Sending a value wakes
one reader. Closing or failing a channel wakes every reader that fits in the
preallocated runnable queue. A wake that encounters a full runnable queue leaves
the waiter registered so the transition can be retried without losing a task.

The fixture starts the consumer before the producer. Its observable sequence is:

```text
consumer -> pending/wait
producer -> send A, B, C; close
consumer -> A/yield -> B/yield -> C/yield -> closed/done
```

The output is `ABCawait ok`. A separate two-reader contract proves that a value
wakes exactly one waiter while close and failure wake the remaining waiters.
The producer's three sends use `@channel.send`, whose status remains explicit;
see `SEND.md`.

A second scheduled consumer uses `@stream.collect` over another `ABC` channel.
It suspends before the producer runs, wakes once, drains the finite stream into
one preallocated collector, and prints `ABCcollect ok`. Separate terminal
contracts prove a drained failed channel produces status `3` and the first byte
beyond collector capacity produces status `4`. See `COLLECT.md` for the
descriptor ABI and pass-order law.

This is the intended compiler shape for a default-await projection: local values
that cross suspension live in the task record, the resume label is represented
by its program counter, and `pending` becomes waiter registration plus return.
The scheduler invokes the resume function stored in the task; it contains no
task-kind dispatch. No platform thread, stackful coroutine, exception, or hidden
allocation is required.

The failed resume branch remains explicit. Surface lowering will write its
diagnostic to `@channel.err` and choose a continuation or `@func.exit`; it will
not convert failure into a value or an implicit throw. Cancellation and external
I/O readiness remain task/scheduler concerns for a later slice.
