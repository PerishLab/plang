# Bounded atom meta-driver

`seed/meta.pir` is the first self-hosted ordering kernel for semantic atoms. It
reads a locally framed manifest from standard input and emits executable pass
names in dependency order, one per line. The current manifest shape is:

```text
ATOM_COUNT
WORK_BUDGET
NAME
CONSUMES_MARKER
EMITS_MARKER_OR_DASH
WRITES
MAX_TOKENS_PER_MARKER
EXECUTABLE
... repeated ATOM_COUNT times
```

The seed admits one through eight atoms. Every field is nonempty and at most 63
bytes; expansion bounds are canonical positive decimal values no greater than
4095. `WORK_BUDGET` is a canonical positive decimal value no greater than
65535. `WRITES` is `-` for the empty set or a `+`-separated set of lowercase
effect names; `EXECUTABLE` is the transport identity. Ordering remains derived
from `CONSUMES_MARKER` and `EMITS_MARKER_OR_DASH`.

For each non-dash emitted marker, exactly one atom must consume it. Duplicate
consumers and unresolved emissions are rejected before ordering. A bounded Kahn
sort then emits the first ready atom in manifest order, producing deterministic
output and rejecting cycles. At most eight 336-byte records are allocated from
the checked arena; all comparisons operate on fixed 64-byte seats.

Before emitting an order, the same kernel reads the original token stream from
file descriptor 3 and performs a bounded marker census. In topological order it
propagates each source marker count across the declared emission edge (one
emitted marker per consumed marker), then proves both of these conservative
bounds against `WORK_BUDGET`:

```text
next token bound = current token bound + marker count * expansion bound
compile work     = sum(current token bound before each atom pass)
```

The token formula intentionally does not subtract the consumed marker framing,
so it remains an upper bound without teaching the planner atom-specific operand
widths. Census and planning retain only counters; source tokens are reread, not
buffered in the meta arena.

`WRITES` is now executable rather than documentary. If two atoms share any
write effect, the dependency graph must contain a path in one direction between
them. An ordered conflict such as `collect -> async` is valid; two unordered
writers are rejected before any pass starts. Read sets and read-after-write
edge inference are deliberately outside this first effect closure.

The canonical manifest deliberately lists `async` before `collect`. Because
collect emits `@await.recv`, the kernel derives this order instead:

```text
collect
async
```

`seed/run-atoms.sh` is a thin platform transport adapter. It presents the source
token file to the kernel on file descriptor 3, asks for the proved order, then
recursively constructs one real Unix pipeline using a new descriptor 3 for the
order file. Atom output is never materialized between passes: only the
at-most-eight-line order file and bounded kernel pipe buffers exist. `pipefail`
preserves any stage failure. The adapter never interprets the manifest graph
itself. PIR1 has no process-spawn primitive yet, so process creation and pipe
transport remain outside the closure alongside assembler, linker, loader, and
ABI. The ordering decision is inside the closure.

The executable contracts prove:

```text
manual collect -> async output == meta-driver output byte for byte
duplicate consumer              -> rejected
unresolved emitted marker       -> rejected
dependency cycle                -> rejected
compile work/token budget        -> rejected before pass launch
unordered overlapping writes    -> rejected before pass launch
malformed write set              -> rejected
meta.pir rebuilt output         == byte-identical fixed point
```

For the canonical `await.pir` source, the census sees 2220 input tokens, two
`@stream.collect` markers, and one source `@await.recv`. Its conservative plan
is 2390 tokens after collect, 2498 after async, and 4610 token-visits of compiler
work, all below the explicit 8192 budget. The actual atom pipeline remains byte
identical to the manually ordered pipeline. Unknown source markers still reach
ordinary PIR1 lowering and are rejected there.
