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

This is an operational boundary, not yet a static borrow checker. A future
surface checker must reject a borrowed object reference stored into continuation
state, while permitting snapshots, explicit moves, and serial capabilities that
lower to these same ordinary values and channel states.
