memory 16777216
bytes ok "channel ok\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: channel contract failed\n"

func channel_new 1
arg %capacity 0
u64 %zero 0
u64 %one 1
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
u64 %closed 2
u64 %buffer_at 0
u64 %capacity_at 8
u64 %write_at 24
u64 %count_at 32
u64 %state_at 40
load64 %state %channel %state_at
nonzero %state rejected
load64 %capacity %channel %capacity_at
load64 %count %channel %count_at
eq %test %count %capacity
nonzero %test full
load64 %buffer %channel %buffer_at
load64 %write %channel %write_at
store8 %buffer %write %value
add %write %write %one
eq %test %write %capacity
zero %test store
u64 %write 0
label store
add %count %count %one
store64 %channel %write_at %write
store64 %channel %count_at %count
ret %one
label rejected
ret %closed
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
zero %test store
u64 %read 0
label store
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

func main 0
u64 %zero 0
u64 %one 1
u64 %two 2
u64 %three 3
u64 %capacity 3
u64 %a 65
u64 %b 66
u64 %c 67
u64 %d 68
call %channel channel_new 1 %capacity
zero %channel limited
alloc %target %one
zero %target limited
call %status channel_send 2 %channel %a
ne %test %status %one
nonzero %test invalid
call %status channel_send 2 %channel %b
ne %test %status %one
nonzero %test invalid
call %status channel_send 2 %channel %c
ne %test %status %one
nonzero %test invalid
call %status channel_send 2 %channel %d
ne %test %status %zero
nonzero %test invalid
call %status channel_recv 2 %channel %target
ne %test %status %one
nonzero %test invalid
load8 %value %target %zero
ne %test %value %a
nonzero %test invalid
call %status channel_send 2 %channel %d
ne %test %status %one
nonzero %test invalid
call %status channel_close 1 %channel
ne %test %status %one
nonzero %test invalid
call %status channel_send 2 %channel %a
ne %test %status %two
nonzero %test invalid
call %status channel_recv 2 %channel %target
ne %test %status %one
nonzero %test invalid
load8 %value %target %zero
ne %test %value %b
nonzero %test invalid
call %status channel_recv 2 %channel %target
ne %test %status %one
nonzero %test invalid
load8 %value %target %zero
ne %test %value %c
nonzero %test invalid
call %status channel_recv 2 %channel %target
ne %test %status %one
nonzero %test invalid
load8 %value %target %zero
ne %test %value %d
nonzero %test invalid
call %status channel_recv 2 %channel %target
ne %test %status %two
nonzero %test invalid
call %failed_channel channel_new 1 %one
zero %failed_channel limited
call %status channel_fail 1 %failed_channel
ne %test %status %one
nonzero %test invalid
call %status channel_recv 2 %failed_channel %target
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
