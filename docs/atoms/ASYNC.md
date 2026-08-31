# Async atom

`seed/async.pir` is the first self-hosted semantic-atom lowering pass. It sits
between the token-stream lexer and the ordinary PIR1 name-lowering pass:

```text
source -> lex -> async -> lower -> emit -> arm64 Darwin assembly
```

The pass recognizes four locally framed markers and copies every other token
unchanged:

```text
@async TASK PC_OFFSET STATE_COUNT
@state STATE
@await.recv STATUS CHANNEL TARGET TASK RESUME_STATE
@await.send STATUS CHANNEL VALUE TASK RESUME_STATE
```

`@async` loads the task program counter and emits a bounded dispatch to one of
the function-local state labels. `@state` materializes one such label.
`@await.recv` stores its resume state before polling the channel. A ready result
continues immediately; a pending result registers the task as a channel waiter
and returns zero to the scheduler. Failed waiter registration replaces
`STATUS` with the explicit failure status `3` and falls through to the caller.

`@await.send` is the symmetric writer policy. It stores the resume state, calls
the synchronous `channel_send`, and falls through immediately for accepted or
terminal status. On full status it registers the task through
`channel_write_wait` and returns zero; registration failure becomes explicit
status `3`. Receive and send sites share one bounded function-local namespace.

The atom's dependencies and observable effects are deliberately narrow:

```text
dependency   channel_recv(channel, target), channel_wait(channel, task)
task read    load pc at PC_OFFSET during dispatch
task write   store RESUME_STATE at PC_OFFSET before receive
pending      register waiter, then ret 0
wait failure set STATUS to 3 and fall through
ready/closed/failed receive status remains in STATUS and falls through
```

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

For the token-stream transform `A`, the executable algebra currently promises:

```text
identity     A(x) = x                         when x contains no async markers
idempotence  A(A(x)) = A(x)                  because lowering removes all markers
frame reset  each @async resets its await-site namespace to zero
expansion    @async(S) -> 15 + 10S tokens; @state -> 2; both await forms -> 36
```

The expansion formula gives a closed output bound before lowering starts. With
`1 <= S <= 8` and at most eight await sites, no marker has input-dependent
iteration beyond those declared bounds. `seed/async-frames.pir` proves two
functions can reuse state and await indices without label collision after
ordinary name lowering. Cross-atom commutation is intentionally not claimed:
it requires a second atom with overlapping effects before the ordering law can
be tested honestly.

`seed/async-max.pir` proves both inclusive upper bounds. The
`seed/async-invalid-*.pir` fixtures prove truncated framing, zero or excessive
state counts, non-canonical state numbers, out-of-range states, and excessive
await sites all fail with one stable diagnostic. `seed/check.sh` also rebuilds
the pass through the closed compiler pair, compares byte-identical output, and
executes the identity, idempotence, frame-isolation, and expansion contracts.
