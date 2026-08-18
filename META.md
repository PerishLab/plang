# Bounded atom meta-driver

`seed/meta.pir` is the first self-hosted ordering kernel for semantic atoms. It
reads a locally framed manifest from standard input and emits executable pass
names in dependency order, one per line. The current manifest shape is:

```text
ATOM_COUNT
NAME
CONSUMES_MARKER
EMITS_MARKER_OR_DASH
EFFECTS
MAX_TOKENS_PER_MARKER
EXECUTABLE
... repeated ATOM_COUNT times
```

The seed admits one through eight atoms. Every field is nonempty and at most 63
bytes; expansion bounds are canonical positive decimal values no greater than
4095. `NAME` and `EFFECTS` are retained as manifest assertions for the human
contract, while ordering is derived only from `CONSUMES_MARKER` and
`EMITS_MARKER_OR_DASH`. `EXECUTABLE` is the transport identity.

For each non-dash emitted marker, exactly one atom must consume it. Duplicate
consumers and unresolved emissions are rejected before ordering. A bounded Kahn
sort then emits the first ready atom in manifest order, producing deterministic
output and rejecting cycles. At most eight 240-byte records are allocated from
the checked arena; all comparisons operate on fixed 64-byte seats.

The canonical manifest deliberately lists `async` before `collect`. Because
collect emits `@await.recv`, the kernel derives this order instead:

```text
collect
async
```

`seed/run-atoms.sh` is a thin platform transport adapter. It asks the kernel for
the order, executes each already-built streaming pass into a disposable file,
and never interprets the manifest graph itself. PIR1 has no process-spawn
primitive yet, so process creation and pipe transport remain outside the
closure alongside assembler, linker, loader, and ABI. The ordering decision is
inside the closure.

The executable contracts prove:

```text
manual collect -> async output == meta-driver output byte for byte
duplicate consumer              -> rejected
unresolved emitted marker       -> rejected
dependency cycle                -> rejected
meta.pir rebuilt output         == byte-identical fixed point
```

The driver does not yet infer effects conflicts or calculate a whole-program
token bound; those fields are carried so the next closure can do so without
changing manifest framing. Unknown source markers still reach ordinary PIR1
lowering and are rejected there.
