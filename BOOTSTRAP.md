# Bootstrap

The first seed targets arm64 Darwin. Each program declares a power-of-two arena
from 4 KiB through 16 MiB; the compiler passes currently use 8 KiB or 32 KiB,
while runtime fixtures may retain wider profiles. Python translates a
deliberately small linear IR into assembly. The platform assembler, linker,
loader, and ABI remain outside the closure.

PIR1 has static bytes, functions of up to eight arguments, thirty local virtual
registers, integer and memory operations, branches, calls, arena allocation,
bounded file input, output, error, and exit. An exhausted arena emits a static
diagnostic and exits without another allocation.

`seed/scan.pir` is the first program of substance written in PIR1. It reads an
arbitrarily long source file through one 4 KiB buffer and validates its byte
surface without retaining the source. It exercises calls, branches, memory,
argv, and bounded stream processing.

The first closure is now closed around a lowering pass and emitter. Python
builds `lower0` and `emit0`; that pair rebuilds `lower1` and `emit1`; and the
rebuilt pair emits byte-identical assembly for both members. It also compiles
and runs `hello.pir` plus the native arithmetic/bitwise fixture. Python remains
as a readable oracle and test fixture, but
is no longer required to reproduce this compiler stage once the pair exists.

The canonical opcode manifest must exactly match the vocabularies embedded in
lower, decode, and emit. `scan.pir` exercises unsigned `lt`, `argv`, `open`, and
`close` through the Python, self-hosted, and fixed-point generations.
`capability.pir` exercises maximum-width u64 construction, eight-argument direct
calls, and eight-argument indirect invokes through the same three generations.
`utf8.pir` proves one-through-four-byte Unicode scalar encoding, explicit
invalid-scalar and capacity statuses, and transactional committed length using
only existing PIR1 operations. `utf8-literal.pir` separately proves that raw
UTF-8 static bytes cross Python, self-hosted, and fixed compilers without the
emitter understanding characters. `utf8-decode.pir` adds a one-byte-at-a-time,
caller-owned incremental decoder whose pending/value/closed/failed statuses
align with channels. `utf8-stream.pir` then composes it with the existing
capacity-one byte channel across every multi-byte availability boundary. See
`UTF8.md`.
The lowerer rejects function declarations wider than eight. Argument indices
are checked against a per-function assembler constant, keeping that local
validation outside runtime code and avoiding mutable cross-helper compiler
state.
Non-main functions additionally define local arity-qualified aliases used only
by direct calls. This turns an unknown target or static signature mismatch into
a link-time failure without retaining a whole-program signature table; indirect
invokes remain outside that static check.

`lower.pir` assigns named registers to explicit frame slots and scopes labels by
function while retaining only one function's small symbol map. `emit.pir`
consumes that normalized token stream. The fixed-point emitter remains bounded
while matching the oracle's operand envelope: u64 literals use one mandatory
low `movz` and up to three assembler-selected `movk` fragments, and calls use at
most the eight arm64 argument registers. These are seed constraints, not
proposed surface-language semantics. Later stages can add channels, structured
IR, syntax, types, and macros from inside the closure.

Operand validation remains layered and bounded: lower rejects a thirty-first
virtual register, emit rejects negative u64 syntax, assembler binding rejects
values outside u64, literal process exits must fit 0..255, and emit requires the
last instruction before each `end` to be `exit` or `ret`. The terminal check is
one bit of compiler state and does not attempt whole-function control-flow
proof. None of these checks enlarges a generated program's runtime state.

Build the current vertical slice with:

```sh
mkdir -p build
python3 seed/boot.py seed/hello.pir build/hello.s
/usr/bin/clang -arch arm64 seed/arm64-darwin.s build/hello.s -o build/hello
build/hello
```

The exhaustion fixture must print `plang: memory limit` to standard error and
exit with status one.

The self-hosted emitter enforces the memory profile with one assembler-time
constant expression. Missing or duplicate memory/main forms are covered by the
platform ABI's required symbols and must fail before execution. The validation
fixtures exercise the same boundary through the Python, self-hosted, and fixed
generations.
Duplicate or unresolved static data, functions, function pointers, and local
labels follow the same rule: deterministic generated symbols make the platform
failure observable before execution without a whole-program registry.

Run the runtime, scanner, lexer, decoder, generated-compiler, and fixed-point
contracts in a disposable build directory with:

```sh
sh seed/check.sh
```

`seed/channel.pir` is the first program built on top of the closed pair. It
implements a fixed-capacity byte channel whose receive result distinguishes
pending, value, closed, and failed states. See `CHANNEL.md` for the executable
ABI and the semantics intentionally deferred to later stages.

`seed/await.pir` then adds a preallocated FIFO scheduler, separate channel reader
and writer waiter queues,
and explicit task continuation. It demonstrates a consumer suspending without
polling, being woken by a producer, yielding between values, and observing the
terminal state after drain. See `AWAIT.md` for the lowering contract.

The hand-written resume state machine has now been replaced by the first
self-hosted atom pass. `seed/async.pir` expands bounded `@async`, `@state`, and
`@await.recv` markers before ordinary PIR1 lowering; the rebuilt pass reaches
the same byte-identical compiler fixed point. See `ASYNC.md` for the local
framing and resource contract.

`seed/collect.pir` is the second self-hosted atom pass. It lowers a bounded byte
stream projection into `@await.recv`, so its executable dependency is
`collect -> async -> lower -> emit`; reversing the atom passes is an explicit
rejected fixture rather than an assumed commutation law. See `COLLECT.md`.

`seed/send.pir` adds explicit synchronous `@channel.send` lowering. It commutes
with both collect and async despite overlapping runtime channel effects, proving
that runtime READS/WRITES and compiler transform dependencies are distinct.
See `SEND.md`.

`seed/meta.pir` now derives that dependency order from the bounded atom
manifest, proves primary framing plus constant/affine auxiliary/extension expansion/work,
rejects unresolved emissions and cycles, and reaches its own byte-identical
fixed point. A thin shell adapter
remains the platform transport for starting the ordered streaming executables.
See `META.md`.

Compiler-pass arenas are now program-owned profiles rather than one runtime
constant: lex, meta, send, collect, async, and lower use 8 KiB; emit uses 32 KiB.
`seed/profile.pir` proves a 4 KiB arena through both compiler generations, and
`seed/report.sh` checks fixed-allocation headroom and repeated helpers. See
`CLOSURE.md` for the measured baseline and the decision to defer pass fusion.

Tasks carry their resume function directly through PIR1's `funcptr` and
`invoke` operations, so the scheduler contains no task-kind switch. The trusted
primitive and the future checked surface boundary are described in
`FUNCTIONS.md`.
