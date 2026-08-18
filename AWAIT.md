# Await lowering slice

`seed/await.pir` is the first executable lowering target for default await. It
adds three fixed-capacity objects to the bounded channel state machine:

```text
scheduler = runnable task FIFO + attached task count
channel   = value FIFO + reader waiter FIFO + writer waiter FIFO + terminal state
task      = resume func + program counter + scheduler + channel + target + done
```

All three objects allocate their complete storage at construction. Enqueue,
wait, wake, resume, close, and fail allocate nothing. The scheduler is
single-threaded and FIFO. Construction enforces `attached tasks <= runnable
capacity`; a task with no scheduler remains valid for synchronous contracts.
Attachment is lifetime-scoped and is not recycled when a task finishes. The
trusted runtime contract also keeps each attached task in exactly one placement:
running, runnable, one waiter FIFO, or done; generated await forms preserve it.

A resumable consumer first polls `channel_recv`. On `pending`, it registers its
task in the channel's waiter FIFO and returns to the scheduler; it is not placed
back on the runnable queue and therefore cannot busy-poll. Sending a value wakes
one reader. Closing or failing a channel wakes every reader. Because a waiter is
not runnable, any legal wake observes `runnable <= attached - waiters`, so the
preallocated queue has room for every task being moved. Queue-full wake is thus
excluded by construction rather than deferred to an unspecified retry.

The symmetric writer path was first proven as a hand-lowered baseline. A send
that observes a full channel records its current program counter, enters the
fixed-capacity writer FIFO, and returns to the scheduler. Each receive that frees
a slot wakes exactly one writer; close and fail wake all writers so they can
observe terminal rejection. The canonical fixture deliberately uses a one-byte
channel, forcing the `A/B/C` producer to suspend and retry without polling or
allocating after construction.

Reader and writer waiters share one bounded FIFO primitive. Each queue is a
40-byte descriptor `{items, capacity, read, write, count}` embedded at channel
offset 48 or 88; push, wake-one, and wake-all receive that base offset explicitly.
The direction-specific entry points retain only readiness policy, so queue
ordering and saturation behavior have one executable implementation.

The fixture starts the consumer before the producer. Its observable sequence is:

```text
consumer -> pending/wait
producer -> send A, B, C; close
consumer -> A/yield -> B/yield -> C/yield -> closed/done
```

The output is `ABCawait ok`. A separate two-reader contract proves that a value
wakes exactly one waiter while close and failure wake the remaining waiters.
Its saturated case uses capacity two: one task is runnable, one is waiting, the
wake fills the queue exactly, and construction of a third attached task fails.
The producer's three sends now use `@await.send`, which preserves the explicit
status of `@channel.send` while lowering the surrounding wait/retry state
machine to ordinary PIR1. See `SEND.md` and `ASYNC.md`.

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
