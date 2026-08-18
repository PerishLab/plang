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

`seed/compose.sh` is the first Python-free source composer. Its manifest starts
with `budget 1..65535`, followed by one to 32 `source PATH` entries. Paths are
relative to the manifest, use a canonical spelling without absolute or dot
segments, cannot repeat, and are lexed in declared order. The first source owns
exactly one `memory` and `main`; later sources own neither. The aggregate token
count is checked after each source and before any semantic pass is launched.
Output is moved into place only after the complete manifest succeeds.

`seed/compose-main.pir` and `seed/compose-library.pir` are its executable lower
bound. Their independently lexed streams form one unit; marker census sees the
library's `@channel.send`, launches only the send pass, then the planned unit
lowers, emits, links, and runs. The library's ordinary arity-qualified function
symbols satisfy the main source's forward calls. Duplicate source, aggregate
overflow, and a second resource/main root have stable fixtures; each rejection
preserves the previous output.

This proves no module runtime or new PIR opcode is required for basic source
composition. It does not yet define namespaces, visibility, cyclic source
graphs, initialization, resource-profile ownership, or a source syntax. Those
features should be introduced only by a fixture that needs them. The composer
presents one deterministic bounded token stream to the existing marker census;
the later semantic expansion/work budget remains independently enforced there.
