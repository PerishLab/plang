# Function values in the closure

PIR1 now has the two operations needed to remove hard-coded task dispatch:

```text
funcptr %destination function
invoke %destination %function_value arity %arguments...
```

`funcptr` materializes the address of a non-main PIR function. `invoke` uses the
same arm64 argument and result convention as `call`, but the callee comes from a
register. Its explicit arity keeps the token stream locally framed and makes the
call site's data flow visible to lowering passes.

`seed/await.pir` stores a resume function value in every task. The scheduler
loads and invokes it without knowing whether the task is a producer, consumer,
I/O continuation, or a future compiler job. This is the smallest operational
meaning of “func as a value” needed by the current closure.

`@stream.utf8.func %receiver` is the first capability-specific materialization.
It lowers to a pointer to the injected arity-two UTF-8 receiver and shares the
same helper closure with direct `@stream.utf8` sites. Source code names the
capability and its function shape, not the compiler-owned `__utf8_*` symbol;
the latter appears only in normalized ordinary PIR.

Direct PIR1 calls reference arity-qualified function aliases, so their static
signature mismatches fail during linking. Function values deliberately erase
that alias: a forged value or mismatched dynamic `invoke` signature can still
fault. The future surface `func` type must carry a checked signature, and a
closure will additionally pair code with captured state. Those facilities
should lower to this code-pointer primitive rather than enlarging the platform
ABI now.

`seed/closure.pir` proves the minimal captured form without a new opcode:

```text
closure = { code, context }
invoke result code N+1 context arguments...
```

Both words are ordinary u64 values in a caller-owned 16-byte descriptor. The
context is also caller-owned; copying a closure copies a borrowed pointer and
does not clone or extend the context lifetime. The fixture captures 40, copies
the descriptor, mutates the original context to 41, then invokes the copy and
observes 41 through an env-first arity-two function. Three aligned records
consume 48 bytes of a 4 KiB arena; an exact 4048-byte remainder succeeds and the
next allocation fails explicitly.

This representation is also the lower bound for an object method without
inheritance: the object address is `context`, and the selected method is
`code`. Surface ownership, capture-by-value, checked signatures, and method
lookup remain semantic layers above the same two-word calling shape.
