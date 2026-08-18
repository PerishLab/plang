memory 4096
bytes ok "object owner ok\n"
bytes limited "object owner memory limit\n"
bytes invalid "object owner invalid\n"

func channel_new 1
arg %capacity 0
u64 %zero 0
u64 %bytes 48
u64 %buffer_at 0
u64 %capacity_at 8
u64 %read_at 16
u64 %write_at 24
u64 %count_at 32
u64 %state_at 40
zero %capacity failed
alloc %channel %bytes
zero %channel failed
alloc %buffer %capacity
zero %buffer failed
store64 %channel %buffer_at %buffer
store64 %channel %capacity_at %capacity
store64 %channel %read_at %zero
store64 %channel %write_at %zero
store64 %channel %count_at %zero
store64 %channel %state_at %zero
ret %channel
label failed
ret %zero
end

func channel_send 2
arg %channel 0
arg %value 1
u64 %zero 0
u64 %one 1
u64 %rejected 2
u64 %buffer_at 0
u64 %capacity_at 8
u64 %write_at 24
u64 %count_at 32
u64 %state_at 40
load64 %state %channel %state_at
nonzero %state terminal
load64 %capacity %channel %capacity_at
load64 %count %channel %count_at
eq %test %count %capacity
nonzero %test full
load64 %buffer %channel %buffer_at
load64 %write %channel %write_at
store8 %buffer %write %value
add %write %write %one
eq %test %write %capacity
zero %test commit
u64 %write 0
label commit
add %count %count %one
store64 %channel %write_at %write
store64 %channel %count_at %count
ret %one
label terminal
ret %rejected
label full
ret %zero
end

func channel_recv 2
arg %channel 0
arg %target 1
u64 %pending 0
u64 %value_status 1
u64 %closed 2
u64 %failed 3
u64 %zero 0
u64 %one 1
u64 %buffer_at 0
u64 %capacity_at 8
u64 %read_at 16
u64 %count_at 32
u64 %state_at 40
load64 %count %channel %count_at
zero %count empty
load64 %buffer %channel %buffer_at
load64 %read %channel %read_at
load8 %value %buffer %read
store8 %target %zero %value
load64 %capacity %channel %capacity_at
add %read %read %one
eq %test %read %capacity
zero %test commit
u64 %read 0
label commit
sub %count %count %one
store64 %channel %read_at %read
store64 %channel %count_at %count
ret %value_status
label empty
load64 %state %channel %state_at
zero %state wait
eq %test %state %one
nonzero %test ended
ret %failed
label ended
ret %closed
label wait
ret %pending
end

func channel_close 1
arg %channel 0
u64 %zero 0
u64 %one 1
u64 %state_at 40
load64 %state %channel %state_at
nonzero %state no
store64 %channel %state_at %one
ret %one
label no
ret %zero
end

func channel_fail 1
arg %channel 0
u64 %zero 0
u64 %one 1
u64 %failed 2
u64 %state_at 40
load64 %state %channel %state_at
nonzero %state no
store64 %channel %state_at %failed
ret %one
label no
ret %zero
end

func object_add 2
arg %object 0
arg %delta 1
u64 %zero 0
load64 %value %object %zero
add %value %value %delta
store64 %object %zero %value
ret %value
end

# owner = {object, request_channel, one-byte scratch}; the descriptor is rounded
# to 32 bytes. A mutable object borrow exists only inside the value branch.
func owner_resume 1
arg %owner 0
u64 %zero 0
u64 %value_status 1
u64 %object_at 0
u64 %channel_at 8
u64 %scratch_at 16
load64 %channel %owner %channel_at
add %target %owner %scratch_at
call %status channel_recv 2 %channel %target
ne %test %status %value_status
nonzero %test terminal
load8 %delta %target %zero
load64 %object %owner %object_at
call %value object_add 2 %object %delta
ret %value_status
label terminal
ret %status
end

func owner_new 2
arg %object 0
arg %channel 1
u64 %zero 0
u64 %bytes 32
u64 %object_at 0
u64 %channel_at 8
alloc %owner %bytes
zero %owner failed
store64 %owner %object_at %object
store64 %owner %channel_at %channel
ret %owner
label failed
ret %zero
end

func main 0
u64 %zero 0
u64 %one 1
u64 %two 2
u64 %three 3
u64 %object_size 16
u64 %method_size 16
u64 %context_at 8
u64 %capacity 2

alloc %object %object_size
zero %object limited
u64 %value 10
store64 %object %zero %value

# A synchronous borrow completes before any suspension boundary.
u64 %delta 5
call %actual object_add 2 %object %delta
u64 %expected 15
ne %test %actual %expected
nonzero %test invalid
u64 %snapshot 0
add %snapshot %snapshot %actual

call %channel channel_new 1 %capacity
zero %channel limited
call %owner owner_new 2 %object %channel
zero %owner limited
alloc %send_capability %method_size
zero %send_capability limited
funcptr %code channel_send
store64 %send_capability %zero %code
store64 %send_capability %context_at %channel
funcptr %resume owner_resume
load64 %code %send_capability %zero
load64 %context %send_capability %context_at

# Capacity two exposes backpressure before the owner consumes anything.
u64 %delta 1
invoke %status %code 2 %context %delta
ne %test %status %one
nonzero %test invalid
u64 %delta 2
invoke %status %code 2 %context %delta
ne %test %status %one
nonzero %test invalid
u64 %delta 3
invoke %status %code 2 %context %delta
ne %test %status %zero
nonzero %test invalid

# The owner is the sole mutable holder and applies requests in FIFO order.
invoke %status %resume 1 %owner
ne %test %status %one
nonzero %test invalid
load64 %actual %object %zero
u64 %expected 16
ne %test %actual %expected
nonzero %test invalid
invoke %status %code 2 %context %delta
ne %test %status %one
nonzero %test invalid
invoke %status %resume 1 %owner
ne %test %status %one
nonzero %test invalid
invoke %status %resume 1 %owner
ne %test %status %one
nonzero %test invalid
load64 %actual %object %zero
u64 %expected 21
ne %test %actual %expected
nonzero %test invalid

# A value snapshot can cross the boundary without borrowing object identity.
u64 %expected 15
ne %test %snapshot %expected
nonzero %test invalid
invoke %status %resume 1 %owner
ne %test %status %zero
nonzero %test invalid

call %status channel_close 1 %channel
ne %test %status %one
nonzero %test invalid
invoke %status %code 2 %context %one
ne %test %status %two
nonzero %test invalid
invoke %status %resume 1 %owner
ne %test %status %two
nonzero %test invalid

# Failure drains an accepted request before the owner observes failed=3.
alloc %failed_object %object_size
zero %failed_object limited
u64 %value 20
store64 %failed_object %zero %value
u64 %capacity 1
call %failed_channel channel_new 1 %capacity
zero %failed_channel limited
call %failed_owner owner_new 2 %failed_object %failed_channel
zero %failed_owner limited
u64 %delta 4
call %status channel_send 2 %failed_channel %delta
ne %test %status %one
nonzero %test invalid
call %status channel_fail 1 %failed_channel
ne %test %status %one
nonzero %test invalid
invoke %status %resume 1 %failed_owner
ne %test %status %one
nonzero %test invalid
load64 %actual %failed_object %zero
u64 %expected 24
ne %test %actual %expected
nonzero %test invalid
invoke %status %resume 1 %failed_owner
ne %test %status %three
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
