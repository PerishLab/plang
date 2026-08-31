# Agents

plang is a language grown outward from a self-hosted compiler closure. PIR1 is
the disposable representation that closure is written in; it is not the surface
language. `examples/*.plang` records intent only — no compiler reads those files
today, and nothing in them should be treated as proved.

## Repository

- `docs/` holds the specification set in four layers. Read `README.md` first;
  it carries the reading order and the per-document status table.
- `seed/` holds the PIR1 compiler closure and its committed cold-start
  bootstrap. It is the only executable implementation today.
- `examples/` holds unproved surface-language intent.
- `crates/api` owns the reusable API surface; `crates/cli` owns command grammar
  and user-facing output. Dependency direction is `cli -> api`.

The Rust workspace is the intended host for work the closure cannot discharge
from inside PIR1 — a surface elaborator is the first such obligation. Its
product capabilities are otherwise undecided; do not infer a domain model,
runtime, or backend from the crate names. Add vocabulary only when its behavior
and ownership have been explicitly settled.

## Cold start

The committed seed is arm64 Darwin assembly under
`seed/bootstrap/arm64-darwin/`, and `seed/bootstrap.sh` hardcodes that path and
`/usr/bin/clang -arch arm64`. **No `seed/*.sh` script runs on any other
platform.** On Linux or Windows, read the documents; do not attempt to execute
or verify the closure locally.

`seed/boot.py` is an independent oracle used for cross-implementation checks. It
is not a cold-bootstrap dependency, and `seed/check-bootstrap.sh` rejects any
Python reference in the bootstrap path.

## Guard

Run `plumb doctor .` before and after changing repository shape. Before landing,
run `cargo fmt --all --check`,
`cargo clippy --locked --workspace --all-targets -- -D warnings`,
`cargo check --locked --workspace --all-targets --release`,
`cargo test --locked --workspace`, and `ectropy .`.

Ectropy scans `docs/**/*.md` as well as the Rust sources, so specification prose
is held to the same structural limits as code.

Never work or commit directly in the clean `main` integration checkout after
the initial repository bootstrap. Use a dedicated task branch and land through
the repository guard.

## Commits

Subject-only, imperative, lower case, no trailing period — for example
`separate identity provenance from borrow checking`. One commit per proved
capability.
