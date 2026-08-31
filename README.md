# plang

plang is being built from a self-hosted compiler closure outward. PIR1 is the
disposable representation that closure is written in; it is not the surface
language. Every semantic capability is introduced as a bounded atom whose
compile-time cost is proved from a manifest before any pass runs, so the
language grows by adding a manifest record rather than by widening the backend.

Three decisions carry most of the design:

- **Semantic capabilities are bounded atoms.** `docs/atoms/META.md` derives pass
  order from consumed and emitted markers and proves token framing, expansion,
  and cumulative compile work against an explicit budget before the first pass
  starts. Runtime effects and compiler transform dependencies are separate
  layers, which `docs/atoms/SEND.md` makes executable.
- **A mutable borrow lives inside one uninterrupted continuation segment.**
  Suspension is the borrow boundary, not the thread. Value snapshot, ownership
  transfer, and serialized capability are the three explicit cross-boundary
  shapes; see `docs/semantics/BORROW.md`.
- **Consumption awaits, projection does not take ownership.** Functions have no
  color; `examples/stream-projection.plang` states the intent and
  `docs/runtime/AWAIT.md` shows the lowering target.

## Layers

Read in this order. Each layer assumes the one above it.

| Layer | Holds | Documents |
| --- | --- | --- |
| `docs/closure/` | PIR1 and the self-hosting bootstrap | `PIR.md` `BOOTSTRAP.md` `CLOSURE.md` `FUNCTIONS.md` |
| `docs/runtime/` | mechanisms written in PIR1 and executed by compiled programs | `CHANNEL.md` `AWAIT.md` |
| `docs/atoms/` | compile-time atom passes and the planner that orders them | `META.md` `ASYNC.md` `SEND.md` `COLLECT.md` `UTF8.md` |
| `docs/semantics/` | surface-language decisions, whether or not they are executable yet | `OBJECTS.md` `BORROW.md` `IDENTITY.md` `IMPORT.md` |

The `docs/runtime/` and `docs/atoms/` split is the same distinction the project
proves in `docs/atoms/SEND.md`: overlapping runtime effects do not manufacture a
compiler-pass dependency.

## Status

`closed` means every claim in the document has an executable fixture that runs
through the Python oracle, the self-hosted compiler, and the fixed point.
`partial` means part of the document is proved and the remainder names its own
next boundary. Open items are listed rather than implied.

| Document | Executable proof | Status |
| --- | --- | --- |
| `closure/PIR.md` | `lex/decode/lower/emit.pir`, `check-opcodes.sh`, `bitwise.pir`, `scan.pir`, `capability.pir` | closed |
| `closure/BOOTSTRAP.md` | `bootstrap.sh`, `check-bootstrap.sh`; stage one equals stage two byte for byte | closed for arm64 Darwin only |
| `closure/CLOSURE.md` | `report.sh`, `profile.pir` | closed as a measurement baseline |
| `closure/FUNCTIONS.md` | `await.pir`, `closure.pir`, `capability.pir` | partial — checked surface `func` signature is open |
| `runtime/CHANNEL.md` | `channel.pir` | partial — multi-producer, cancellation, typed elements, error payloads are open |
| `runtime/AWAIT.md` | `await.pir` | partial — cancellation and external I/O readiness are open |
| `atoms/META.md` | `meta.pir`, `seed/atoms*.manifest` | closed; five of eight atom slots are in use |
| `atoms/ASYNC.md` | `async.pir`, `async-max.pir`, `async-invalid-*.pir` | closed |
| `atoms/SEND.md` | `send.pir`, commutation with collect and async | closed |
| `atoms/COLLECT.md` | `collect.pir`, `collect-order.pir`, `collect-max.pir`, `collect-invalid-*.pir` | closed |
| `atoms/UTF8.md` | `utf8.pir`, `utf8-decode.pir`, `utf8-stream.pir`, `utf8-pass.pir` | closed |
| `semantics/OBJECTS.md` | `object.pir` | closed |
| `semantics/BORROW.md` | `borrow.pir`, `borrow-await.pir`, `object-owner.pir` | partial — lexical identity is proved; alias derivation and ownership move are open |
| `semantics/IDENTITY.md` | `borrow-identity.pir` | partial — alias provenance is proved; use-after-move rejection is open |
| `semantics/IMPORT.md` | `compose.sh`, `compose-main.pir`, `compose-library.pir` | partial — source composition is proved; namespaces, visibility, cyclic source graphs, and initialization order are open |

Two open items gate the semantic core rather than merely extending it:

- **Use-after-move.** `docs/semantics/IDENTITY.md` states that encoding this as
  another marker-only pass would catch only marked uses. It requires a surface
  elaborator that knows which operands are owned bindings, so it is the first
  obligation that cannot be discharged from inside PIR1.
- **Module structure.** `docs/semantics/IMPORT.md` composes sources but defines
  no namespace, visibility, or initialization order.

## Intent, not implementation

`examples/*.plang` records the intended surface language. No compiler reads
those files today; every implementation in this repository is written directly
in PIR1. They are kept as the statement of where the semantic layers are
heading, and should be treated as unproved.

## Build

The committed cold-start seed is 178,498 bytes of arm64 Darwin assembly under
`seed/bootstrap/arm64-darwin/`, plus an 87-line runtime shim in
`seed/arm64-darwin.s`. The platform assembler, linker, loader, and ABI remain
outside the closure; Python does not.

```sh
sh seed/bootstrap.sh        # cold bootstrap, no Python
sh seed/check-bootstrap.sh  # same path in a disposable directory
sh seed/check.sh            # runtime, scanner, lexer, atom, and fixed-point contracts
sh seed/report.sh           # size, arena, and duplicate-helper measurement
```

`seed/boot.py` is an independent oracle used for cross-implementation checks. It
is not a cold-bootstrap dependency, and `check-bootstrap.sh` rejects any Python
reference in the bootstrap path.

## Pending

A second backend targeting LLVM IR is under consideration, which would make the
cold-start seed target-neutral and reduce the per-platform cost to the runtime
shim. Two decisions precede it: whether the arm64 Darwin emitter is replaced or
frozen as a reference oracle, and what reproducibility is promised once final
code generation moves inside LLVM. The validation arguments in
`docs/closure/PIR.md` and `docs/closure/BOOTSTRAP.md` that rely on assembler
constant expressions will be restated once those are settled.
