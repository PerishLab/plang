# Bounded channel slice

`seed/channel.pir` is the first executable channel contract. It is a bounded
single-threaded byte stream backed by one ring buffer. Construction allocates a
48-byte descriptor and the requested capacity from the checked arena. Sending,
receiving, closing, and failing allocate nothing.

The descriptor stores the buffer pointer, capacity, read cursor, write cursor,
queued byte count, and terminal state as six u64 fields. Its state is one of:

```text
0 open
1 closed
2 failed
```

`channel_send(channel, byte)` returns:

```text
0 full: the caller encountered backpressure
1 accepted
2 rejected: the channel is closed or failed
```

`channel_recv(channel, target)` writes one byte to `target` only when it returns
`1`:

```text
0 pending: open, with no queued value
1 value
2 closed: drained and closed
3 error: drained and failed
```

Queued values remain readable after close or failure; the terminal result is
observed only after the queue drains. This separates temporary absence,
successful termination, and failure without exceptions or sentinel bytes.

The slice is deliberately synchronous and non-blocking. A future default-await
projection can suspend on `pending`, and a scheduler can wake it when send or a
terminal transition changes the channel. Neither requires changing this state
machine. Multi-producer safety, cancellation propagation, typed elements, and
error payloads remain outside this first contract.

`AWAIT.md` extends this state machine with fixed-capacity waiter and runnable
queues and demonstrates the first non-polling default-await lowering target.
