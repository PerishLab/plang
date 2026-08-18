memory 4096
bytes ok "utf8 stream ok\n"
bytes limited "plang0: memory limit\n"
bytes invalid "utf8 stream failed\n"

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

# @stream.utf8 injects the shared decoder closure once for all sites below.
func main 0
u64 %zero 0
u64 %one 1
u64 %pending 0
u64 %value_status 1
u64 %closed 2
u64 %failed 3
u64 %capacity 1
u64 %statesize 40
u64 %value_at 24
alloc %state %statesize
zero %state limited
store64 %state %zero %zero
call %channel channel_new 1 %capacity
zero %channel limited
@stream.utf8.func %receiver

# U+03BB split across two availability windows.
u64 %byte 206
call %status channel_send 2 %channel %byte
ne %test %status %one
nonzero %test invalid
invoke %status %receiver 2 %channel %state
ne %test %status %pending
nonzero %test invalid
u64 %byte 187
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %value_status
nonzero %test invalid
load64 %value %state %value_at
u64 %expected 955
ne %test %value %expected
nonzero %test invalid

# U+4F60 split at every byte.
u64 %byte 228
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %pending
nonzero %test invalid
u64 %byte 189
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %pending
nonzero %test invalid
u64 %byte 160
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %value_status
nonzero %test invalid
load64 %value %state %value_at
u64 %expected 20320
ne %test %value %expected
nonzero %test invalid

# U+1F600 split at every byte.
u64 %byte 240
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %pending
nonzero %test invalid
u64 %byte 159
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %pending
nonzero %test invalid
u64 %byte 152
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %pending
nonzero %test invalid
u64 %byte 128
call %status channel_send 2 %channel %byte
@stream.utf8 %status %channel %state
ne %test %status %value_status
nonzero %test invalid
load64 %value %state %value_at
u64 %expected 128512
ne %test %value %expected
nonzero %test invalid
call %status channel_close 1 %channel
@stream.utf8 %status %channel %state
ne %test %status %closed
nonzero %test invalid

# A partial scalar followed by close is failed.
call %truncated channel_new 1 %capacity
zero %truncated limited
u64 %byte 226
call %status channel_send 2 %truncated %byte
@stream.utf8 %status %truncated %state
ne %test %status %pending
nonzero %test invalid
call %status channel_close 1 %truncated
@stream.utf8 %status %truncated %state
ne %test %status %failed
nonzero %test invalid

# Upstream failure remains failure.
call %broken channel_new 1 %capacity
zero %broken limited
call %status channel_fail 1 %broken
@stream.utf8 %status %broken %state
ne %test %status %failed
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

