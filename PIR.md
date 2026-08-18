# PIR1

PIR1 is the disposable closure language accepted by `seed/boot.py`. It is not
the plang surface language. It exists only to express the first compiler in a
form that the first compiler can later rebuild.

A program declares the 16 MiB seed profile, static byte strings, and functions.
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

`seed/async.pir` is the first self-hosted semantic-atom pass in front of that
pair. It expands locally framed `@async`, `@state`, and `@await.recv` markers
without retaining an AST, and is itself rebuilt to a byte-identical fixed
point. See `ASYNC.md` for its bounds and explicit failure contract.

`seed/collect.pir` precedes async lowering and expands bounded
`@stream.collect` projections into `@await.recv`. This establishes the first
tested dependency edge between atom passes. See `COLLECT.md`.

`seed/meta.pir` reads up to eight atom records, derives their pass order from
consumed and emitted markers, and rejects unresolved edges or cycles. It is
self-hosted; only process transport remains in `seed/run-atoms.sh`. See
`META.md`.

The emitter implements only the PIR1 operations needed by the pair and hello
fixture, with calls capped at four arguments and small immediates emitted through
one `movz`. `seed/boot.py` remains the broader PIR1 oracle. The lowering pass is
deliberately not a general symbol table or AST: it is the smallest stateful
stream transform that restores readable names without widening the trusted
backend.
