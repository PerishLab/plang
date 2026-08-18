# Identity provenance before borrowing

The borrow pass should receive canonical identity tokens, not infer identity
from arbitrary PIR registers. Four source-level flows reduce as follows:

| Flow | Runtime copy | Identity result | Static obligation |
| --- | --- | --- | --- |
| record value copy | fields copied | no shared identity | each value is independent |
| object handle copy | pointer copied | same identity token | aliases share one borrow state |
| method closure copy | `{code, context}` copied | context keeps the same identity token | invoking the copy borrows its context identity |
| explicit ownership move | handle transferred | identity token is unchanged | old handle becomes unusable |

Only the last column needs surface provenance. Once elaboration assigns an
opaque token such as `%identity0`, every alias-derived borrow emits that token:

```text
@borrow.mut %identity0
... synchronous access through object, alias, method context, or moved handle ...
@borrow.end %identity0
```

The token is compiler metadata, not a runtime register requirement. The borrow
pass erases it with the marker, so alias tracking adds no runtime word and does
not enlarge PIR1. This also means identity equality need not be rediscovered by
pointer comparison inside `borrow.pir`.

`seed/borrow-identity.pir` exercises object-pointer aliasing, a copied method
closure context, and a move-shaped new handle. All three accesses use the same
canonical token and normalize to ordinary PIR. Record-copy independence is
already executable in `seed/object.pir`.

This does not yet prove use-after-move rejection. That requires the surface
elaborator to know which operands are owned handles and to invalidate the source
binding. Encoding that rule as another marker-only pass would catch only marked
uses and create a false sense of completeness. The next boundary is therefore a
small ownership/provenance elaboration over typed bindings, not a new runtime or
borrow atom.
