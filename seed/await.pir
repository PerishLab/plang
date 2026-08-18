memory 16777216
bytes ok "await ok\n"
bytes collect_ok "collect ok\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: await contract failed\n"

func scheduler_new 1
arg %capacity 0
u64 %zero 0
u64 %bytes 48
u64 %scale 8
u64 %queue_at 0
u64 %capacity_at 8
u64 %read_at 16
u64 %write_at 24
u64 %count_at 32
u64 %attached_at 40
zero %capacity failed
alloc %scheduler %bytes
zero %scheduler failed
mul %queue_bytes %capacity %scale
alloc %queue %queue_bytes
zero %queue failed
store64 %scheduler %queue_at %queue
store64 %scheduler %capacity_at %capacity
store64 %scheduler %read_at %zero
store64 %scheduler %write_at %zero
store64 %scheduler %count_at %zero
store64 %scheduler %attached_at %zero
ret %scheduler
label failed
ret %zero
end

func scheduler_enqueue 2
arg %scheduler 0
arg %task 1
u64 %zero 0
u64 %one 1
u64 %scale 8
u64 %queue_at 0
u64 %capacity_at 8
u64 %write_at 24
u64 %count_at 32
load64 %capacity %scheduler %capacity_at
load64 %count %scheduler %count_at
eq %test %count %capacity
nonzero %test full
load64 %queue %scheduler %queue_at
load64 %write %scheduler %write_at
mul %offset %write %scale
store64 %queue %offset %task
add %write %write %one
eq %test %write %capacity
zero %test store
u64 %write 0
label store
add %count %count %one
store64 %scheduler %write_at %write
store64 %scheduler %count_at %count
ret %one
label full
ret %zero
end

func scheduler_next 1
arg %scheduler 0
u64 %zero 0
u64 %one 1
u64 %scale 8
u64 %queue_at 0
u64 %capacity_at 8
u64 %read_at 16
u64 %count_at 32
load64 %count %scheduler %count_at
zero %count empty
load64 %queue %scheduler %queue_at
load64 %read %scheduler %read_at
mul %offset %read %scale
load64 %task %queue %offset
load64 %capacity %scheduler %capacity_at
add %read %read %one
eq %test %read %capacity
zero %test store
u64 %read 0
label store
sub %count %count %one
store64 %scheduler %read_at %read
store64 %scheduler %count_at %count
ret %task
label empty
ret %zero
end

func channel_new 2
arg %capacity 0
arg %wait_capacity 1
u64 %zero 0
u64 %bytes 128
u64 %scale 8
u64 %buffer_at 0
u64 %capacity_at 8
u64 %read_at 16
u64 %write_at 24
u64 %count_at 32
u64 %state_at 40
u64 %waiters_at 48
u64 %wait_capacity_at 56
u64 %wait_read_at 64
u64 %wait_write_at 72
u64 %wait_count_at 80
zero %capacity failed
zero %wait_capacity failed
alloc %channel %bytes
zero %channel failed
alloc %buffer %capacity
zero %buffer failed
mul %wait_bytes %wait_capacity %scale
alloc %waiters %wait_bytes
zero %waiters failed
alloc %writer_waiters %wait_bytes
zero %writer_waiters failed
store64 %channel %buffer_at %buffer
store64 %channel %capacity_at %capacity
store64 %channel %read_at %zero
store64 %channel %write_at %zero
store64 %channel %count_at %zero
store64 %channel %state_at %zero
store64 %channel %waiters_at %waiters
store64 %channel %wait_capacity_at %wait_capacity
store64 %channel %wait_read_at %zero
store64 %channel %wait_write_at %zero
store64 %channel %wait_count_at %zero
u64 %offset 88
store64 %channel %offset %writer_waiters
u64 %offset 96
store64 %channel %offset %wait_capacity
u64 %offset 104
store64 %channel %offset %zero
u64 %offset 112
store64 %channel %offset %zero
u64 %offset 120
store64 %channel %offset %zero
ret %channel
label failed
ret %zero
end

func channel_write_wait 2
arg %channel 0
arg %task 1
u64 %zero 0
u64 %one 1
u64 %scale 8
u64 %task_scheduler_at 16
u64 %capacity_at 8
u64 %count_at 32
u64 %state_at 40
u64 %waiters_at 88
u64 %wait_capacity_at 96
u64 %wait_write_at 112
u64 %wait_count_at 120
load64 %state %channel %state_at
nonzero %state ready
load64 %capacity %channel %capacity_at
load64 %count %channel %count_at
eq %test %count %capacity
zero %test ready
load64 %wait_capacity %channel %wait_capacity_at
load64 %wait_count %channel %wait_count_at
eq %test %wait_count %wait_capacity
nonzero %test full
load64 %waiters %channel %waiters_at
load64 %wait_write %channel %wait_write_at
mul %offset %wait_write %scale
store64 %waiters %offset %task
add %wait_write %wait_write %one
eq %test %wait_write %wait_capacity
zero %test store
u64 %wait_write 0
label store
add %wait_count %wait_count %one
store64 %channel %wait_write_at %wait_write
store64 %channel %wait_count_at %wait_count
ret %one
label ready
load64 %scheduler %task %task_scheduler_at
call %test scheduler_enqueue 2 %scheduler %task
ret %test
label full
ret %zero
end

func channel_wait 2
arg %channel 0
arg %task 1
u64 %zero 0
u64 %one 1
u64 %scale 8
u64 %task_scheduler_at 16
u64 %count_at 32
u64 %state_at 40
u64 %waiters_at 48
u64 %wait_capacity_at 56
u64 %wait_write_at 72
u64 %wait_count_at 80
load64 %count %channel %count_at
nonzero %count ready
load64 %state %channel %state_at
nonzero %state ready
load64 %wait_capacity %channel %wait_capacity_at
load64 %wait_count %channel %wait_count_at
eq %test %wait_count %wait_capacity
nonzero %test full
load64 %waiters %channel %waiters_at
load64 %wait_write %channel %wait_write_at
mul %offset %wait_write %scale
store64 %waiters %offset %task
add %wait_write %wait_write %one
eq %test %wait_write %wait_capacity
zero %test store
u64 %wait_write 0
label store
add %wait_count %wait_count %one
store64 %channel %wait_write_at %wait_write
store64 %channel %wait_count_at %wait_count
ret %one
label ready
load64 %scheduler %task %task_scheduler_at
call %test scheduler_enqueue 2 %scheduler %task
ret %test
label full
ret %zero
end

func channel_wake_one 1
arg %channel 0
u64 %zero 0
u64 %one 1
u64 %scale 8
u64 %task_scheduler_at 16
u64 %waiters_at 48
u64 %wait_capacity_at 56
u64 %wait_read_at 64
u64 %wait_count_at 80
load64 %wait_count %channel %wait_count_at
zero %wait_count empty
load64 %waiters %channel %waiters_at
load64 %wait_read %channel %wait_read_at
mul %offset %wait_read %scale
load64 %task %waiters %offset
load64 %scheduler %task %task_scheduler_at
call %test scheduler_enqueue 2 %scheduler %task
zero %test full
load64 %wait_capacity %channel %wait_capacity_at
add %wait_read %wait_read %one
eq %test %wait_read %wait_capacity
zero %test store
u64 %wait_read 0
label store
sub %wait_count %wait_count %one
store64 %channel %wait_read_at %wait_read
store64 %channel %wait_count_at %wait_count
ret %one
label empty
ret %one
label full
ret %zero
end

func channel_wake_all 1
arg %channel 0
u64 %zero 0
u64 %one 1
u64 %wait_count_at 80
label waiter
load64 %count %channel %wait_count_at
zero %count done
call %test channel_wake_one 1 %channel
zero %test full
jump waiter
label done
ret %one
label full
ret %zero
end

func channel_wake_writer_one 1
arg %channel 0
u64 %zero 0
u64 %one 1
u64 %scale 8
u64 %task_scheduler_at 16
u64 %waiters_at 88
u64 %wait_capacity_at 96
u64 %wait_read_at 104
u64 %wait_count_at 120
load64 %wait_count %channel %wait_count_at
zero %wait_count empty
load64 %waiters %channel %waiters_at
load64 %wait_read %channel %wait_read_at
mul %offset %wait_read %scale
load64 %task %waiters %offset
load64 %scheduler %task %task_scheduler_at
call %test scheduler_enqueue 2 %scheduler %task
zero %test full
load64 %wait_capacity %channel %wait_capacity_at
add %wait_read %wait_read %one
eq %test %wait_read %wait_capacity
zero %test store
u64 %wait_read 0
label store
sub %wait_count %wait_count %one
store64 %channel %wait_read_at %wait_read
store64 %channel %wait_count_at %wait_count
ret %one
label empty
ret %one
label full
ret %zero
end

func channel_wake_writer_all 1
arg %channel 0
u64 %zero 0
u64 %one 1
u64 %wait_count_at 120
label waiter
load64 %count %channel %wait_count_at
zero %count done
call %test channel_wake_writer_one 1 %channel
zero %test full
jump waiter
label done
ret %one
label full
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
call %test channel_wake_one 1 %channel
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
call %test channel_wake_writer_one 1 %channel
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
u64 %failed 2
u64 %state_at 40
load64 %state %channel %state_at
eq %test %state %failed
nonzero %test no
nonzero %state wake
store64 %channel %state_at %one
label wake
call %test channel_wake_all 1 %channel
zero %test no
call %test channel_wake_writer_all 1 %channel
ret %test
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
eq %test %state %one
nonzero %test no
nonzero %state wake
store64 %channel %state_at %failed
label wake
call %test channel_wake_all 1 %channel
zero %test no
call %test channel_wake_writer_all 1 %channel
ret %test
label no
ret %zero
end

func task_new 4
arg %resume 0
arg %scheduler 1
arg %channel 2
arg %target 3
u64 %zero 0
u64 %one 1
u64 %bytes 56
u64 %resume_at 0
u64 %pc_at 8
u64 %scheduler_at 16
u64 %channel_at 24
u64 %target_at 32
u64 %done_at 40
u64 %count_at 48
alloc %task %bytes
zero %task failed
store64 %task %resume_at %resume
store64 %task %pc_at %zero
store64 %task %scheduler_at %scheduler
store64 %task %channel_at %channel
store64 %task %target_at %target
store64 %task %done_at %zero
store64 %task %count_at %zero
zero %scheduler ready
u64 %capacity_at 8
u64 %attached_at 40
load64 %capacity %scheduler %capacity_at
load64 %attached %scheduler %attached_at
eq %test %attached %capacity
nonzero %test failed
add %attached %attached %one
store64 %scheduler %attached_at %attached
label ready
ret %task
label failed
ret %zero
end

func collector_new 1
arg %capacity 0
u64 %zero 0
u64 %bytes 32
u64 %buffer_at 0
u64 %capacity_at 8
u64 %length_at 16
u64 %scratch_at 24
zero %capacity failed
alloc %collector %bytes
zero %collector failed
alloc %buffer %capacity
zero %buffer failed
store64 %collector %buffer_at %buffer
store64 %collector %capacity_at %capacity
store64 %collector %length_at %zero
store64 %collector %scratch_at %zero
ret %collector
label failed
ret %zero
end

func consumer_resume 1
arg %task 0
@async %task 8 1
@state 0
u64 %one 1
u64 %closed 2
u64 %failed 3
u64 %expected 3
u64 %fd 1
u64 %scheduler_at 16
u64 %channel_at 24
u64 %target_at 32
u64 %done_at 40
u64 %count_at 48
load64 %channel %task %channel_at
load64 %target %task %target_at
@await.recv %status %channel %target %task 0
eq %test %status %one
nonzero %test value
eq %test %status %closed
nonzero %test ended
jump bad
label value
write %wrote %fd %target %one
load64 %count %task %count_at
add %count %count %one
store64 %task %count_at %count
load64 %scheduler %task %scheduler_at
call %test scheduler_enqueue 2 %scheduler %task
zero %test bad
u64 %pending 0
ret %pending
label ended
load64 %count %task %count_at
ne %test %count %expected
nonzero %test bad
store64 %task %done_at %one
out ok
ret %one
label bad
store64 %task %done_at %one
err invalid
ret %failed
end

func collect_resume 1
arg %task 0
@async %task 8 1
@state 0
u64 %one 1
u64 %closed 2
u64 %expected 3
u64 %offset 24
load64 %channel %task %offset
u64 %offset 32
load64 %collector %task %offset
@stream.collect %status %channel %collector %task 0
ne %test %status %closed
nonzero %test bad
u64 %offset 16
load64 %length %collector %offset
ne %test %length %expected
nonzero %test bad
u64 %offset 0
load64 %buffer %collector %offset
write %wrote %one %buffer %length
u64 %offset 40
store64 %task %offset %one
out collect_ok
ret %one
label bad
u64 %offset 40
store64 %task %offset %one
err invalid
ret %expected
end

func collect_status 1
arg %task 0
@async %task 8 1
@state 0
u64 %offset 24
load64 %channel %task %offset
u64 %offset 32
load64 %collector %task %offset
@stream.collect %status %channel %collector %task 0
ret %status
end

func producer_resume 1
arg %task 0
u64 %zero 0
u64 %one 1
u64 %failed 3
u64 %channel_at 24
u64 %done_at 40
load64 %channel %task %channel_at
@async %task 8 3
@state 0
u64 %value 65
@await.send %status %channel %value %task 0
ne %test %status %one
nonzero %test bad
@state 1
u64 %value 66
@await.send %status %channel %value %task 1
ne %test %status %one
nonzero %test bad
@state 2
u64 %value 67
@await.send %status %channel %value %task 2
ne %test %status %one
nonzero %test bad
call %status channel_close 1 %channel
zero %status bad
store64 %task %done_at %one
ret %one
label bad
store64 %task %done_at %one
err invalid
ret %failed
end

func task_resume 1
arg %task 0
u64 %resume_at 0
load64 %resume %task %resume_at
invoke %result %resume 1 %task
ret %result
end

func scheduler_run 2
arg %scheduler 0
arg %budget 1
u64 %zero 0
u64 %one 1
u64 %failed 3
u64 %steps 0
label task
eq %test %steps %budget
nonzero %test exhausted
call %next scheduler_next 1 %scheduler
zero %next idle
call %result task_resume 1 %next
eq %test %result %failed
nonzero %test exhausted
add %steps %steps %one
jump task
label idle
ret %one
label exhausted
ret %zero
end

func collect_terminal_contract 0
u64 %zero 0
u64 %one 1
u64 %two 2
u64 %failed 3
u64 %full 4
u64 %a 65
u64 %b 66
call %channel channel_new 2 %two %one
zero %channel bad
call %collector collector_new 1 %one
zero %collector bad
call %status channel_send 2 %channel %a
ne %test %status %one
nonzero %test bad
call %status channel_send 2 %channel %b
ne %test %status %one
nonzero %test bad
call %status channel_close 1 %channel
zero %status bad
call %task task_new 4 %zero %zero %channel %collector
zero %task bad
call %status collect_status 1 %task
ne %test %status %full
nonzero %test bad
call %channel channel_new 2 %one %one
zero %channel bad
call %collector collector_new 1 %one
zero %collector bad
call %status channel_fail 1 %channel
zero %status bad
call %task task_new 4 %zero %zero %channel %collector
zero %task bad
call %status collect_status 1 %task
ne %test %status %failed
nonzero %test bad
ret %one
label bad
ret %zero
end

func wake_contract 0
u64 %zero 0
u64 %one 1
u64 %scheduler_capacity 2
u64 %channel_capacity 1
u64 %wait_capacity 2
u64 %value 65
funcptr %resume consumer_resume
call %scheduler scheduler_new 1 %scheduler_capacity
zero %scheduler bad
call %channel channel_new 2 %channel_capacity %wait_capacity
zero %channel bad
alloc %target %one
zero %target bad
call %first task_new 4 %resume %scheduler %channel %target
zero %first bad
call %second task_new 4 %resume %scheduler %channel %target
zero %second bad
call %third task_new 4 %resume %scheduler %channel %target
nonzero %third bad
call %status channel_wait 2 %channel %first
zero %status bad
call %status scheduler_enqueue 2 %scheduler %second
zero %status bad
call %status channel_send 2 %channel %value
zero %status bad
call %next scheduler_next 1 %scheduler
ne %test %next %second
nonzero %test bad
call %next scheduler_next 1 %scheduler
ne %test %next %first
nonzero %test bad
call %status channel_recv 2 %channel %target
ne %test %status %one
nonzero %test bad
call %status channel_wait 2 %channel %second
zero %status bad
call %status channel_close 1 %channel
zero %status bad
call %next scheduler_next 1 %scheduler
ne %test %next %second
nonzero %test bad
call %next scheduler_next 1 %scheduler
nonzero %next bad
call %failed_channel channel_new 2 %channel_capacity %wait_capacity
zero %failed_channel bad
call %status channel_wait 2 %failed_channel %first
zero %status bad
call %status channel_fail 1 %failed_channel
zero %status bad
call %next scheduler_next 1 %scheduler
ne %test %next %first
nonzero %test bad
call %next scheduler_next 1 %scheduler
nonzero %next bad
ret %one
label bad
ret %zero
end

func main 0
u64 %zero 0
u64 %one 1
u64 %two 2
u64 %scheduler_capacity 8
u64 %channel_capacity 1
u64 %collector_capacity 3
u64 %wait_capacity 4
u64 %budget 32
call %status wake_contract 0
zero %status invalid
call %status collect_terminal_contract 0
zero %status invalid
funcptr %consumer_resume consumer_resume
funcptr %producer_resume producer_resume
call %scheduler scheduler_new 1 %scheduler_capacity
zero %scheduler limited
call %channel channel_new 2 %channel_capacity %wait_capacity
zero %channel limited
alloc %target %one
zero %target limited
call %consumer task_new 4 %consumer_resume %scheduler %channel %target
zero %consumer limited
call %producer task_new 4 %producer_resume %scheduler %channel %zero
zero %producer limited
call %status scheduler_enqueue 2 %scheduler %consumer
zero %status invalid
call %status scheduler_enqueue 2 %scheduler %producer
zero %status invalid
call %status scheduler_run 2 %scheduler %budget
zero %status invalid
u64 %done_at 40
load64 %done %consumer %done_at
zero %done invalid
load64 %done %producer %done_at
zero %done invalid
funcptr %consumer_resume collect_resume
call %scheduler scheduler_new 1 %scheduler_capacity
zero %scheduler limited
call %channel channel_new 2 %channel_capacity %wait_capacity
zero %channel limited
call %collector collector_new 1 %collector_capacity
zero %collector limited
call %consumer task_new 4 %consumer_resume %scheduler %channel %collector
zero %consumer limited
call %producer task_new 4 %producer_resume %scheduler %channel %zero
zero %producer limited
call %status scheduler_enqueue 2 %scheduler %consumer
zero %status invalid
call %status scheduler_enqueue 2 %scheduler %producer
zero %status invalid
call %status scheduler_run 2 %scheduler %budget
zero %status invalid
load64 %done %consumer %done_at
zero %done invalid
load64 %done %producer %done_at
zero %done invalid
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
