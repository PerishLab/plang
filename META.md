# Bounded atom meta-driver

`seed/meta.pir` is the self-hosted planning kernel for semantic atoms. It reads
a locally framed manifest from standard input, reads the original token stream
from file descriptor 3, proves a bounded plan, and emits executable pass names
in dependency order. The manifest shape is:

```text
ATOM_COUNT
WORK_BUDGET
NAME
CONSUMES_MARKER
EMITS_MARKER_OR_DASH
AUX_MARKER_OR_DASH
READS
WRITES
INPUT_TOKENS_PER_MARKER
OUTPUT_TOKENS_PER_MARKER
EMITTED_MARKERS_PER_MARKER
AUX_INPUT_TOKENS
AUX_MODE_C_OR_A
AUX_BASE
AUX_SCALE
AUX_OPERAND_OFFSET
EXECUTABLE
... repeated ATOM_COUNT times
```

The seed admits one through eight atoms. Text fields are nonempty and at most
63 bytes. `READS` and `WRITES` are `-` for the empty set or `+`-separated
lowercase effect names. Token framing is canonical positive decimal no greater
than 4095; emitted-marker multiplicity is one canonical digit from zero through
eight. A dash emission requires multiplicity zero, and a non-dash emission
requires a positive multiplicity. `AUX_MARKER` accounts for a structural marker
consumed by the same pass but not participating in graph edges. Its mode is
`c` for constant output `BASE`, or `a` for affine output
`BASE + SCALE * canonical_decimal_operand[OFFSET]`. Constant rules require zero
scale and offset; affine rules require both to be positive. `WORK_BUDGET` is
1..65535.

For each emitted marker, exactly one atom must consume it. Duplicate consumers,
unresolved emissions, and cycles are rejected. A bounded Kahn sort chooses the
first ready atom in manifest order, giving a deterministic plan. The registry
uses at most eight 408-byte records; together with the input window and operand
seat, fixed allocation is 7424 bytes inside the 8 KiB arena.

The source census retains only token and marker counters. In topological order,
the planner applies each atom's declared bounded transfer:

```text
next tokens = current tokens
            - marker count * input framing
            + marker count * output framing

next tokens               -= auxiliary count * auxiliary input framing
next tokens               += sum(auxiliary constant/affine outputs)
next emitted-marker count += marker count * emission multiplicity
compile work               += current tokens before each pass
```

Primary marker transfers are exact. During the same streaming census, an affine
rule retains only a bounded operand countdown and accumulated output sum. For
`@async %task 8 1`, the manifest declares `4 -> 15 + 10 * operand[3]`, yielding
25 tokens without teaching the planner what a state is. A missing, overlapping,
non-canonical, or out-of-range operand rejects the plan. Every intermediate
token count and cumulative work must fit the explicit budget; source tokens are
reread rather than buffered in the meta arena.

`READS` and `WRITES` describe effects of the generated program, not mutations
performed by compiler passes. The third atom makes the distinction executable:
`send` and `async` both touch channel state at runtime, but their transforms
consume disjoint markers and commute byte for byte. The same is true for
`send` and `collect`. Runtime effect overlap therefore does not manufacture a
compiler dependency or rejection. Compiler ordering is derived only from
marker production and consumption; runtime effects remain structured input for
future scheduling and race analysis.

The canonical manifest deliberately lists `async` before `collect`, but collect
emits `@await.recv`, so the kernel derives:

```text
send
collect
async
```

`seed/run-atoms.sh` presents the source on descriptor 3, obtains the proved
order, then recursively constructs one Unix pipeline. Atom output is not
materialized between passes; only the at-most-eight-line order file and bounded
kernel pipe buffers exist. Process creation and pipe transport remain platform
services outside PIR1 alongside assembler, linker, loader, and ABI.

The executable contracts prove:

```text
manual send -> collect -> async == planned output byte for byte
send -> async                  == async -> send
send -> collect                == collect -> send
overlapping runtime writes     != compiler-pass conflict
duplicate/unresolved/cycle     -> rejected
duplicate primary/aux marker   -> rejected
framing or emission mismatch   -> rejected
invalid/incomplete affine rule -> rejected
compile work/token overflow    -> rejected before pass launch
meta.pir rebuilt output        == byte-identical fixed point
```

For canonical `await.pir`, the census sees 2657 source tokens, three
`@channel.send`, two `@stream.collect`, one source `@await.recv`, and four
`@async` frames. The exact plan reaches 2663 tokens after send, 2821 after
collect, and 3015 after async, matching every materialized stage. Cumulative
compiler work is 8141, leaving 51 tokens under the explicit 8192 budget. The
tight boundary is useful pressure: the hand-lowered writer suspension baseline
must become a smaller `@await.send` marker rather than silently widening the
budget. Unknown source markers
still reach ordinary PIR1 lowering and are rejected there.
