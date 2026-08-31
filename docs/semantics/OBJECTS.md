# Records and identity objects

The first object boundary distinguishes two source-level meanings while keeping
one minimal PIR vocabulary:

| Shape | Copy meaning | Method meaning |
| --- | --- | --- |
| `record` | fields are copied into independent storage | functions receive a record value or explicit address |
| `object` | a stable caller-owned context has identity | a method value is `{code, context}` and borrows that identity |

Neither shape requires inheritance, a vtable, retain/release, garbage
collection, or a new opcode. `seed/object.pir` allocates two counters with
different contexts and materializes the same `counter_add` code for both.
Invoking each method mutates only its context. Copying one method descriptor
continues to address the original object.

Behavior reuse is explicit composition. The fixture builds a delegate method
whose context is another method descriptor; its ordinary env-first function
loads that closure and invokes it. There is no parent lookup, implicit method
resolution, or hidden object header.

Stable identity permits aliases but does not make concurrent mutation safe.
Borrow checking, scheduling ownership, or channel serialization must establish
that separately. Object and method lifetimes likewise remain explicit: the
caller owns the context storage, and borrowed method descriptors cannot extend
it. Surface syntax and static method signatures can lower to these rules after
their first real use case is known.

`BORROW.md` selects the first suspension boundary: mutable borrows remain inside
one uninterrupted continuation segment; snapshots, ownership transfer, and
serialized capabilities are the explicit cross-boundary forms.
