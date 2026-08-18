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

The first closure is now closed. Python builds `emit0`; `emit0` rebuilds
`emit1`; and `emit1` rebuilds byte-identical assembly. The rebuilt compiler also
compiles and runs `hello.pir`. Python remains as a readable oracle and test
fixture, but is no longer required to reproduce this compiler stage once an
`emit1` binary exists.

The fixed-point profile is intentionally smaller than all of PIR1. Its source
uses explicit frame slots (`%r8`, `%r16`, ...), globally unique labels, u64
immediates that fit one `movz`, and calls of at most four arguments. These are
seed constraints, not proposed surface-language semantics. They avoid pulling
a symbol table, integer parser, or general register allocator into the first
closure. Later stages can add channels, structured IR, syntax, types, and macros
from inside it.

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
