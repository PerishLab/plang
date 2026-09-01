# Agents

plang is a language being designed from LLVM IR upward.

On 2026-09-01 this repository was reset to zero. The PIR1 self-hosting closure,
its arm64 Darwin seed, the fifteen specification documents, the three surface
examples, and the Rust workspace were deleted, along with Plumb, Ectropy and the
forge workflows. Git history keeps all of it. Nothing in the working tree
depends on any of it.

The reset followed from dropping the bump arena. That arena had made a set of
hard questions look answered when they were only deferred, and it turned memory
errors into stale reads rather than crashes. Everything the arena shaped went
with it.

## Where truth lives

- **Source** — `puzzles/` holds plang source. It does not exist yet; the
  language has no implementation.
- **Decisions** — the Concord task `perish.code/plang-semantic-core-closed`.
  Read it before proposing anything. Settled rulings are Decisions, open forks
  are Questions.

This repository carries no prose about the design, and none should be added. A
claim that cannot be executed belongs in Concord, not in a file.

## Standing language rulings

These survived the reset because they are surface decisions, independent of the
memory model and the backend:

- The source extension is `.plang`. The compilation and distribution unit is a
  `puzzle`. A puzzle builds to a binary or a `plib`; there is no C library
  product, and the C ABI stays confined inside a plib.
- `@import("a.b.c")` binds an already built artifact and never pulls source. It
  names; the manifest resolves.
- **plang has no comments.** Text that needs expressing goes through the std
  trace library, so an explanation is checked by the compiler instead of being
  left to rot.

The memory model, borrowing, ownership, the type system, the surface syntax and
the bootstrap host are all open.

## Working here

Bring changes through a task branch.

Keep the tree minimal until the skeleton is settled. Plumb, Ectropy and the
workflows were removed for that reason and should return only when there is
something for them to guard.
