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

PIR1 remains trusted and unsafe: a forged function value or mismatched dynamic
signature can fault. The future surface `func` type must carry a checked
signature, and a closure will additionally pair code with captured state. Those
facilities should lower to this code-pointer primitive rather than enlarging the
platform ABI now.
