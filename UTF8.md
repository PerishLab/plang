# UTF-8 capability boundary

UTF-8 is a native plang semantic capability, not a PIR1 opcode. PIR1 carries
bytes, pointers, lengths, integer/bit operations, bounded memory, and explicit
status. Those primitives are sufficient to encode Unicode scalar values
without adding character knowledge to the emitter or runtime ABI.

`seed/utf8.pir` is the executable capability proof. Its encoder accepts a
caller-owned byte buffer, capacity, committed-length cell, and one scalar. It
returns `1=encoded`, `2=invalid scalar`, or `3=capacity`. Capacity and scalar
validity are checked before the first store, so failure leaves the committed
length and byte prefix unchanged. One scalar emits at most four bytes and the
encoder performs no allocation.

The fixture covers the four UTF-8 widths with U+0041, U+03BB, U+4F60, and
U+1F600. It also rejects a surrogate, a value above U+10FFFF, and a four-byte
write into three bytes of remaining capacity through the Python, self-hosted,
and fixed compiler generations.

`seed/utf8-decode.pir` proves the incremental inverse without hiding a stream
buffer. Its caller-owned 32-byte state is `{remaining, scalar, minimum, value}`;
each feed consumes exactly one byte and returns the existing channel-shaped
status `0=pending`, `1=value`, or `3=failed`. A terminal maps to `2=closed` only
when no partial scalar remains; truncated close and upstream failure map to
failed. Invalid continuation, overlong forms, surrogates, values above
U+10FFFF, and invalid leading bytes reset the partial sequence explicitly.

`seed/utf8-stream.pir` composes that state with the existing bounded byte
channel. `utf8_stream_recv(channel, state)` repeatedly consumes already-ready
bytes, returns only on a scalar, true upstream pending, or terminal, and keeps a
split sequence in a caller-owned 40-byte descriptor (the decoder state plus one
scratch byte). Capacity-one channel fixtures split 2/3/4-byte scalars at every
availability boundary and preserve the four statuses through clean close,
truncated close, and upstream failure.

The shared decoder helpers occupy 345 PIR tokens and the generic channel
projection wrapper 70. `seed/utf8-pass.pir` now makes that boundary executable:

```text
@stream.utf8 STATUS CHANNEL STATE
=> call STATUS __utf8_stream_recv 2 CHANNEL STATE
```

The first marker causes the pass to append the namespaced 415-token ordinary
PIR helper closure once; later markers add only their two-token call-site delta.
The 13-site fixture therefore transfers exactly from 769 to 1,210 tokens:
`769 + 13 * (6 - 4) + 415`. A second pass is byte-identical, marker-free input
is byte-identical, and Python, self-hosted, and fixed pass generations all emit
the same normalized program. The caller still owns the explicit 40-byte state,
and the target program still supplies ordinary `channel_recv`; no UTF-8 opcode,
runtime ABI, module loader, or hidden allocation was introduced.

Inlining only the decoder at two sites has a 690-token lower bound before site
framing. The injected closure is therefore the selected normal form: one
feature cost per program plus a small per-site call cost.

Static `bytes` declarations are transport, not Unicode syntax. A raw UTF-8
literal such as `"λ你好😀"` reaches the assembler as the same source bytes;
neither lower nor emit interprets code points. JSON `\uXXXX` decoding,
normalization, grapheme semantics, and dynamic UTF-8 validation belong to
future fully lowered atoms. Arbitrary non-UTF-8 static data may later receive a
separate byte-exact surface form when a real binary fixture requires it.
