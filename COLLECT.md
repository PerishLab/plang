# Bounded stream collection atom

`seed/collect.pir` lowers the first scalar projection over an asynchronous byte
stream. It runs before `seed/async.pir` and recognizes one locally framed
marker:

```text
@stream.collect STATUS CHANNEL COLLECTOR TASK RESUME_STATE
```

The collector is persistent state allocated before execution:

```text
offset 0   buffer pointer
offset 8   capacity in bytes
offset 16  committed length
offset 24  one-byte receive scratch
```

The descriptor costs 32 bytes plus exactly `capacity` bytes from the checked
arena. Collection, suspension, wake, append, close, failure, and overflow
allocate nothing. `CHANNEL`, `COLLECTOR`, and `TASK` must survive suspension;
the generated locals do not.

The atom expands to a local loop containing one `@await.recv`. Values are copied
from scratch into `buffer[length]`; closed and failed channels are observed only
after their queued bytes drain. `STATUS` has this terminal contract:

```text
0 pending          task was registered and the async atom returns to scheduler
1 value            consumed internally; never falls through
2 closed           successful finite projection
3 failed           channel or waiter-registration failure
4 capacity         first excess byte was observed but not stored
```

The channel ABI has no peek operation, so distinguishing “exactly full and then
closed” from “one byte too many” requires receiving the next event. Status `4`
therefore consumes the first excess byte. The source channel is a stream, not a
replayable collection; future fan-out belongs above this primitive.

Each `@async` marker resets a function-local collect-site index. One frame may
contain at most eight collect sites, every resume state is one canonical digit
from zero through seven, and generated names occupy the reserved
`%__collect_`/`__collect_` namespaces. One marker deterministically expands from
six to 85 tokens. The pass itself retains only a 4 KiB input window and five
64-byte operand buffers.

For token transform `C` and async transform `A`, the executable laws are:

```text
x without collect markers: x |> C = x
idempotence:                x |> C |> C = x |> C
normal form:                x |> C |> A contains no atom markers
required order:             C precedes A because C emits @await.recv
counterexample:             x |> A |> C is rejected by ordinary PIR1 lowering
```

This is a dependency partial order, not a claim that atom passes commute.
`seed/collect-order.pir` proves both the accepted order and the rejected reverse
order. `seed/collect-max.pir` proves the inclusive eight-site bound and exact
expansion. The await runtime fixture proves suspension and successful collection
of `ABC`, then separately proves failed-channel status `3` and capacity status
`4`. The pass is rebuilt through the closed compiler pair to a byte-identical
fixed point.
