# Async atom

`seed/async.pir` is the first self-hosted semantic-atom lowering pass. It sits
between the token-stream lexer and the ordinary PIR1 name-lowering pass:

```text
source -> lex -> async -> lower -> emit -> arm64 Darwin assembly
```

The pass recognizes three locally framed markers and copies every other token
unchanged:

```text
@async TASK PC_OFFSET STATE_COUNT
@state STATE
@await.recv STATUS CHANNEL TARGET TASK RESUME_STATE
```

`@async` loads the task program counter and emits a bounded dispatch to one of
the function-local state labels. `@state` materializes one such label.
`@await.recv` stores its resume state before polling the channel. A ready result
continues immediately; a pending result registers the task as a channel waiter
and returns zero to the scheduler. Failed waiter registration returns the
explicit PIR1 failure status `3`.

The seed contract allows one through eight states and at most eight await sites
per async function. State and resume-state operands are one decimal digit and
must be smaller than the declared state count. Each copied operand is at most
63 bytes, and the pass owns only one fixed 4 KiB input window plus five fixed
64-byte operand buffers inside the 16 MiB arena. It never retains a function or
source AST.

Generated labels are function-local after ordinary name lowering. Generated
registers use the reserved `%__async_` namespace; PIR1 is trusted input, so the
future surface/meta compiler is responsible for keeping user identifiers out
of that namespace. Marker placement inside a function is likewise an upstream
structural obligation. This pass establishes local atom framing and bounded
lowering, not a second whole-program parser.

`seed/async-max.pir` proves both inclusive upper bounds. The
`seed/async-invalid-*.pir` fixtures prove truncated framing, zero or excessive
state counts, non-canonical state numbers, out-of-range states, and excessive
await sites all fail with one stable diagnostic. `seed/check.sh` also rebuilds
the pass through the closed compiler pair and compares byte-identical output.
