# Borrowing across suspension

A mutable object borrow belongs to one uninterrupted synchronous continuation
segment. It is not retained across `await`, pending return, or transfer to a
different continuation. This rule is semantic and does not depend on the
current scheduler's task record layout.

There are three explicit ways to carry useful state across that boundary:

| Shape | Cross-boundary meaning |
| --- | --- |
| value snapshot | copy immutable data; no object identity is borrowed |
| ownership transfer | move the whole identity; the sender stops using it |
| serialized capability | send bounded requests to the identity's unique owner |

`seed/object-owner.pir` proves the third shape with existing primitives. A
producer receives `{channel_send, request_channel}` rather than an object
pointer. The owner continuation stores `{object, request_channel, scratch}` and
calls `channel_recv` before acquiring a synchronous mutable borrow. Pending,
closed, and failed return without touching the object; a value request invokes
`object_add` and releases the borrow before `owner_resume` returns.

The capacity-two request channel accepts deltas 1 and 2, rejects delta 3 with
explicit backpressure, and accepts it after the owner consumes one request.
FIFO owner resumes move the object from 15 through 16 to 21. An immutable value
snapshot remains 15. Close rejects later sends and resumes as closed. A failed
channel drains its accepted delta 4, updating a second object from 20 to 24,
then resumes as failed. No lock, polling loop, hidden allocation, or shared
mutable method descriptor is introduced.

`seed/borrow.pir` now makes the local boundary executable as a self-hosted
compile-time pass. It recognizes three framed atoms:

```text
@borrow.mut OBJECT
@borrow.end OBJECT
@borrow.await.recv STATUS CHANNEL TARGET TASK RESUME_STATE
```

Mutable borrows form a lexical stack scoped to one `func ... end`. Opening a
borrow rejects a duplicate live identity or a ninth nesting level. Closing must
name the top borrow exactly. A function cannot end with a live borrow, and an
known suspension atoms (`@await.recv`, `@await.send`, and `@stream.collect`)
cannot occur until the stack is empty. The open and close atoms erase to
zero tokens; a legal borrow-aware await becomes the ordinary `@await.recv` atom.
The async pass therefore remains ignorant of borrowing, while the meta-driver
derives `borrow -> async` from ordinary marker production and consumption.

The checker allocates one 4096-byte input window, one 64-byte operand seat, and
eight 72-byte borrow records: 4736 fixed bytes in an 8192-byte arena. It neither
allocates runtime state nor emits runtime instructions. Marker-free input and
already lowered output are byte-identical fixed points.

`seed/borrow-await.pir` proves a synchronous mutable access followed by release
and suspension. The negative fixtures reject a borrow across await, duplicate
identity, non-LIFO close, ninth live borrow, function-end leak, and direct use of
each existing suspension marker. This first
closure deliberately models lexical identity names rather than general aliases;
alias derivation and ownership moves remain later surface-type questions.
