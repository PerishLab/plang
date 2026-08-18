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

Static `bytes` declarations are transport, not Unicode syntax. A raw UTF-8
literal such as `"λ你好😀"` reaches the assembler as the same source bytes;
neither lower nor emit interprets code points. JSON `\uXXXX` decoding,
normalization, grapheme semantics, and dynamic UTF-8 validation belong to
future fully lowered atoms. Arbitrary non-UTF-8 static data may later receive a
separate byte-exact surface form when a real binary fixture requires it.
