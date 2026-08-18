# PIR1

PIR1 is the disposable closure language accepted by `seed/boot.py`. It is not
the plang surface language. It exists only to express the first compiler in a
form that the first compiler can later rebuild.

A program declares a power-of-two arena from 4 KiB through 16 MiB, static byte
strings, and functions.
`main` receives the platform `argc` and `argv` when declared with arity two.
Other functions receive up to eight arguments. Each function owns at most
thirty named u64 virtual registers backed by one fixed stack frame.

The current instructions are:

```text
arg u64 data funcptr
add sub mul and or xor shl shr
eq ne lt le slt
load8 load64 store8 store64
alloc argv read write open close call invoke
label jump zero nonzero
out err exit ret
```

PIR1 is a trusted unsafe representation. Its raw loads and stores are not the
future safe plang memory model. The seed is single-threaded, all dynamic storage
comes from one checked bump arena, and arena exhaustion returns zero without
allocating. Static bytes, code, stack, and platform loader memory are still
outside that arena in this stage.

The emitter binds each `memory` operand to an assembler constant and checks the
4 KiB..16 MiB power-of-two profile before reserving the arena. Missing or
duplicate memory declarations and missing or duplicate `main` definitions are
rejected by their required `_plang_memory_limit` and `_main` ABI symbols during
assembly or linking; the closure does not duplicate those symbol tables.

Every instruction is locally framed by its opcode. Variable-arity calls carry
their arity explicitly as `call destination function arity arguments...`, so a
consumer of the token stream never needs source line boundaries or a global
function table merely to find the next instruction.

`funcptr` materializes a non-main PIR function as a trusted code pointer, and
`invoke` calls such a value with the same explicit-arity framing. See
`FUNCTIONS.md` for the boundary between this unsafe closure primitive and a
future checked surface `func` type.

The closure member is a one-pass PIR1-to-assembly emitter. PIR1 is designed for
that pass: every instruction occupies one line, functions use a fixed frame,
labels may resolve forward, and source can be read through a bounded line buffer
without retaining a program AST.

`seed/lex.pir` establishes the emitter's input boundary. It turns arbitrarily
long source into one token per line through a fixed 4 KiB window. JSON strings
remain one token, may cross input windows, and are rejected when unterminated.
Because output is a stream, a late lexical failure does not retract tokens that
were already committed; consumers decide whether they require transactional
buffering.

`seed/decode.pir` consumes that stream through another fixed 4 KiB window. Its
compact `opcode arity` table makes the instruction vocabulary data rather than
a branch forest. It validates its own tokenized source without reconstructing
source lines or retaining an AST.

`seed/lower.pir` consumes the lexer's token stream, assigns each function's
named registers to consecutive eight-byte frame slots, and qualifies local
labels with their function name. It retains at most thirty names of sixty-three
bytes for the active function and streams every other token directly onward.

`seed/emit.pir` consumes that normalized stream in one pass and emits linkable
arm64 Darwin assembly. The Python seed compiles both members once; the resulting
pair compiles both sources again, and the next generation is byte-identical.
The rebuilt pair also compiles `hello.pir` successfully.

`seed/check-opcodes.sh` extracts the instruction vocabulary embedded in lower,
decode, and emit and requires exact equality. `seed/bitwise.pir` and
`seed/scan.pir` then exercise arithmetic/bitwise and `lt/argv/open/close`
semantics through the Python, self-hosted, and fixed-point generations.
`seed/capability.pir` does the same for the operand boundary: full-width u64
constants plus direct and indirect calls with eight arguments.
Function declarations wider than eight are rejected by both the oracle and
lowering pass. The streaming emitter publishes each current function arity as
an assembler-time constant; every `arg` emits a conditional `.error`, so an
index outside that function's arity fails before linking or execution without
adding compiler-side persistent state.
Each non-main function also defines a local arity-qualified alias. Direct `call`
targets that alias, so unknown functions and declared/call-site arity mismatch
remain forward-reference friendly but fail as unresolved symbols at link time.
Dynamic `invoke` cannot use this static proof and remains a trusted code-pointer
operation.

`seed/async.pir` is the first self-hosted semantic-atom pass in front of that
pair. It expands locally framed `@async`, `@state`, and `@await.recv` markers
without retaining an AST, and is itself rebuilt to a byte-identical fixed
point. See `ASYNC.md` for its bounds and explicit failure contract.

`seed/collect.pir` precedes async lowering and expands bounded
`@stream.collect` projections into `@await.recv`. This establishes the first
tested dependency edge between atom passes. See `COLLECT.md`.

`seed/send.pir` expands explicit non-blocking channel sends. Its byte-identical
commutation with collect and async separates runtime effects from compiler pass
dependencies. See `SEND.md`.

`seed/meta.pir` reads up to eight atom records, derives pass order from consumed
and emitted markers, and proves primary framing, constant/affine auxiliary and extension
expansion, emission multiplicity, and cumulative work against an explicit budget. It is
self-hosted; only process transport remains in `seed/run-atoms.sh`. See
`META.md`.

The emitter implements the listed arithmetic, bitwise, comparison, memory, and
control operations needed by the closure fixtures. Calls and invokes use all
eight arm64 argument registers. A u64 literal always emits its low `movz`; the
assembler conditionally retains only nonzero 16-bit `movk` fragments, so the
self-hosted emitter accepts the full unsigned range without embedding a second
integer parser. `seed/bitwise.pir` and `seed/capability.pir` keep these semantics
aligned with the Python oracle through both compiler generations. The lowering
pass is deliberately not a general symbol table or AST: it is the smallest
stateful stream transform that restores readable names without widening the
trusted backend.
