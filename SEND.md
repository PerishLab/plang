# Explicit channel send atom

`seed/send.pir` lowers one synchronous, non-allocating channel operation:

```text
@channel.send STATUS CHANNEL VALUE
```

It expands from four tokens to the ordinary six-token PIR1 call:

```text
call STATUS channel_send 2 CHANNEL VALUE
```

The channel ABI remains explicit. `STATUS` is `0` for full/backpressure, `1`
for accepted, and `2` when a closed or failed channel rejects the value. The
atom neither waits nor retries; an asynchronous send policy would be a distinct
atom with its own suspension contract.

The pass has no site table and imposes no hidden per-function marker limit. It
retains one 4 KiB token window and three 64-byte operands, so source size and the
manifest work budget provide the enclosing bound. Marker-free identity,
idempotence, malformed framing rejection, runtime execution in `await.pir`, and
self-hosted byte-identical fixed point are executable fixtures.

Because send emits no semantic marker, it commutes with both current transforms:

```text
S(A(x)) = A(S(x))
S(C(x)) = C(S(x))
```

This is also the first evidence that runtime effects and compiler transform
effects are separate layers: send and async may both access the same channel at
runtime while their compile-time rewrites remain independent.
