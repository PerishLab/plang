# Bootstrap

The first seed targets arm64 Darwin and owns one 16 MiB arena. Python translates
a deliberately small linear IR into assembly. The platform assembler, linker,
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
and runs `hello.pir`. Python remains as a readable oracle and test fixture, but
is no longer required to reproduce this compiler stage once the pair exists.

`lower.pir` assigns named registers to explicit frame slots and scopes labels by
function while retaining only one function's small symbol map. `emit.pir`
consumes that normalized token stream. The fixed-point emitter remains smaller
than all of PIR1: u64 immediates fit one `movz`, calls have at most four
arguments, and only operations used by the pair are implemented. These are seed
constraints, not proposed surface-language semantics. Later stages can add
channels, structured IR, syntax, types, and macros from inside the closure.

Build the current vertical slice with:

```sh
mkdir -p build
python3 seed/boot.py seed/hello.pir build/hello.s
/usr/bin/clang -arch arm64 seed/arm64-darwin.s build/hello.s -o build/hello
build/hello
```

The exhaustion fixture must print `plang: memory limit` to standard error and
exit with status one.

Run the runtime, scanner, lexer, decoder, generated-compiler, and fixed-point
contracts in a disposable build directory with:

```sh
sh seed/check.sh
```

`seed/channel.pir` is the first program built on top of the closed pair. It
implements a fixed-capacity byte channel whose receive result distinguishes
pending, value, closed, and failed states. See `CHANNEL.md` for the executable
ABI and the semantics intentionally deferred to later stages.

`seed/await.pir` then adds a preallocated FIFO scheduler, channel waiter queue,
and explicit task continuation. It demonstrates a consumer suspending without
polling, being woken by a producer, yielding between values, and observing the
terminal state after drain. See `AWAIT.md` for the lowering contract.
