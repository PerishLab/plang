memory 4096
bytes ok "object ok\n"
bytes limited "object memory limit\n"
bytes invalid "object invalid\n"

func counter_add 2
arg %object 0
arg %delta 1
u64 %zero 0
load64 %value %object %zero
add %value %value %delta
store64 %object %zero %value
ret %value
end

func counter_delegate 2
arg %method 0
arg %delta 1
u64 %zero 0
u64 %context_at 8
load64 %code %method %zero
load64 %context %method %context_at
invoke %result %code 2 %context %delta
ret %result
end

func main 0
u64 %zero 0
u64 %context_at 8
u64 %record_size 16
u64 %value 7
u64 %other 9

# A value record copy owns independent field storage.
alloc %record %record_size
alloc %record_copy %record_size
zero %record limited
zero %record_copy limited
store64 %record %zero %value
store64 %record %context_at %other
load64 %word %record %zero
store64 %record_copy %zero %word
load64 %word %record %context_at
store64 %record_copy %context_at %word
u64 %value 8
store64 %record_copy %zero %value
load64 %actual %record %zero
u64 %expected 7
ne %test %actual %expected
nonzero %test invalid

# Identity objects share method code but retain distinct stable contexts.
alloc %left %record_size
alloc %right %record_size
alloc %left_method %record_size
alloc %right_method %record_size
alloc %method_copy %record_size
alloc %delegate %record_size
zero %left limited
zero %right limited
zero %left_method limited
zero %right_method limited
zero %method_copy limited
zero %delegate limited
u64 %value 10
store64 %left %zero %value
u64 %value 20
store64 %right %zero %value
funcptr %code counter_add
store64 %left_method %zero %code
store64 %left_method %context_at %left
store64 %right_method %zero %code
store64 %right_method %context_at %right

load64 %word %left_method %zero
load64 %actual %right_method %zero
ne %test %word %actual
nonzero %test invalid
load64 %word %left_method %context_at
load64 %actual %right_method %context_at
eq %test %word %actual
nonzero %test invalid

u64 %delta 2
load64 %code %left_method %zero
load64 %context %left_method %context_at
invoke %actual %code 2 %context %delta
u64 %expected 12
ne %test %actual %expected
nonzero %test invalid

u64 %delta 3
load64 %code %right_method %zero
load64 %context %right_method %context_at
invoke %actual %code 2 %context %delta
u64 %expected 23
ne %test %actual %expected
nonzero %test invalid

# Copying a method preserves the borrowed object identity.
load64 %word %left_method %zero
store64 %method_copy %zero %word
load64 %word %left_method %context_at
store64 %method_copy %context_at %word
u64 %delta 1
load64 %code %method_copy %zero
load64 %context %method_copy %context_at
invoke %actual %code 2 %context %delta
u64 %expected 13
ne %test %actual %expected
nonzero %test invalid

# Explicit delegation composes behavior without inheritance or a vtable.
funcptr %code counter_delegate
store64 %delegate %zero %code
store64 %delegate %context_at %right_method
u64 %delta 4
load64 %code %delegate %zero
load64 %context %delegate %context_at
invoke %actual %code 2 %context %delta
u64 %expected 27
ne %test %actual %expected
nonzero %test invalid
load64 %actual %left %zero
u64 %expected 13
ne %test %actual %expected
nonzero %test invalid
load64 %actual %right %zero
u64 %expected 27
ne %test %actual %expected
nonzero %test invalid

out ok
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
