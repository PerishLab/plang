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
task record carries an explicit placement state: detached, new, runnable,
running, reader-wait, writer-wait, or done. Queue operations validate and commit
those transitions only after their underlying push succeeds. Duplicate enqueue,
waiting from a non-running task, resuming a non-runnable task, and returning
suspended without leaving `running` are therefore explicit contract failures.
Detached tasks remain valid for direct synchronous contracts.

The encoding is chosen to make the transition law small, not to expose a
surface ABI: `running=0`, `new=1`, `reader-wait=2`, and `writer-wait=3` are the
only states accepted by enqueue; `runnable=4`, `done=5`, and `detached=6` are
rejected by one bounded range check. Wait registration accepts only the
singleton interval `running=0`; the push policy is its target placement, with
`runnable=4` selecting the scheduler interval and waiter targets selecting the
singleton. This helper currently needs only four arguments within the
eight-argument seed ABI and the self-hosted emitter's current opcode set.
Dequeue requires exactly `runnable` and
changes it to `running` only when the FIFO commit occurs. An invalid queue head
is reported to `scheduler_run` through a private sentinel and becomes scheduler
failure rather than false idle.

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

The runnable queue and both waiter queues share one placement-aware bounded
FIFO push kernel. It receives an allowed placement interval and target state,
validates before touching the queue, and commits the target only after the push.
Each queue has a 40-byte descriptor `{items, capacity, read, write, count}` at
its owner's base offset 0, 48, or 88. Waiter wake keeps its transactional rule:
enqueue the task first and consume the waiter only after enqueue succeeds. The
direction-specific entry points retain only readiness policy, so queue ordering
and saturation behavior have one executable implementation without weakening
wake failure semantics.

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
