memory 4096
bytes ok "borrow identity ok\n"
bytes limited "borrow identity memory limit\n"
bytes invalid "borrow identity invalid\n"

func object_add 2
arg %object 0
arg %delta 1
u64 %zero 0
load64 %value %object %zero
add %value %value %delta
store64 %object %zero %value
ret %value
end

func main 0
u64 %zero 0
u64 %bytes 8
u64 %context_at 8
alloc %object %bytes
u64 %closure_bytes 16
alloc %method %closure_bytes
alloc %method_copy %closure_bytes
zero %object limited
zero %method limited
zero %method_copy limited
u64 %value 10
store64 %object %zero %value

# A copied object handle remains the same canonical identity.
add %alias %object %zero
@borrow.mut %identity0
u64 %delta 1
call %actual object_add 2 %alias %delta
@borrow.end %identity0

# Copying a method closure preserves the identity carried by context.
funcptr %code object_add
store64 %method %zero %code
store64 %method %context_at %object
load64 %word %method %zero
store64 %method_copy %zero %word
load64 %word %method %context_at
store64 %method_copy %context_at %word
@borrow.mut %identity0
load64 %code %method_copy %zero
load64 %context %method_copy %context_at
u64 %delta 2
invoke %actual %code 2 %context %delta
@borrow.end %identity0

# An ownership move changes the usable handle, not the canonical identity.
add %moved %alias %zero
@borrow.mut %identity0
u64 %delta 3
call %actual object_add 2 %moved %delta
@borrow.end %identity0
u64 %expected 16
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
