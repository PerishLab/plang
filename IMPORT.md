# Import boundary

`@import` currently has no executable meaning. Three superficially similar
operations belong to different holders:

| Need | Minimal holder | Why it is not a generic `@import` |
| --- | --- | --- |
| Use a semantic capability | its call-site atom | marker census already selects and budgets the closure exactly |
| Materialize a capability as a `func` value | a capability-specific func-value atom | it must expose a stable public signature, not retain a private `__*` helper |
| Compose source files | the build/source composer | path resolution and source ordering are input transport, not target semantics |

The first two operations can remain locally framed and completely lower away.
The third necessarily touches the host path namespace before the semantic pass
pipeline. Mixing it into a semantic atom would make pass output depend on
ambient filesystem state and would break marker-local algebra.

`seed/compose-main.pir` and `seed/compose-library.pir` are the current executable
lower bound. The Python-free bootstrap lexes them independently, concatenates
their token streams in declared order, then lowers, emits, links, and runs the
single resulting unit. The library has neither `memory` nor `main`; its ordinary
arity-qualified function symbol satisfies the main source's forward call.

This proves no module runtime or new PIR opcode is required for basic source
composition. It does not yet define namespaces, visibility, cyclic source
graphs, initialization, resource-profile ownership, or a source syntax. Those
features should be introduced only by a fixture that needs them. A future
source composer must preserve declared order, reject an unbounded aggregate
before launching semantic passes, and present one deterministic token stream to
the existing marker census.
