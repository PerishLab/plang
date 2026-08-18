memory 8192
bytes asyncword "@async"
bytes stateword "@state"
bytes awaitword "@await.recv"
bytes sendawaitword "@await.send"
bytes numbers "0\n1\n2\n3\n4\n5\n6\n7\n"
bytes states "__async_state_0\n__async_state_1\n__async_state_2\n__async_state_3\n__async_state_4\n__async_state_5\n__async_state_6\n__async_state_7\n"
bytes ready "__async_ready_0\n__async_ready_1\n__async_ready_2\n__async_ready_3\n__async_ready_4\n__async_ready_5\n__async_ready_6\n__async_ready_7\n"
bytes waiting "__async_waiting_0\n__async_waiting_1\n__async_waiting_2\n__async_waiting_3\n__async_waiting_4\n__async_waiting_5\n__async_waiting_6\n__async_waiting_7\n"
bytes async_a "u64\n%__async_zero\n0\nu64\n%__async_pc_at\n"
bytes async_b "load64\n%__async_pc\n"
bytes async_c "%__async_pc_at\n"
bytes dispatch_a "u64\n%__async_value\n"
bytes dispatch_b "eq\n%__async_test\n%__async_pc\n%__async_value\nnonzero\n%__async_test\n"
bytes dispatch_end "u64\n%__async_failed\n3\nret\n%__async_failed\n"
bytes labelword "label\n"
bytes await_a "u64\n%__async_value\n"
bytes await_b "store64\n"
bytes await_c "%__async_pc_at\n%__async_value\ncall\n"
bytes await_d "channel_recv\n2\n"
bytes await_e "nonzero\n"
bytes await_f "call\n%__async_test\nchannel_wait\n2\n"
bytes await_g "nonzero\n%__async_test\n"
bytes await_h "u64\n"
bytes await_i "3\njump\n"
bytes await_j "ret\n%__async_zero\nlabel\n"
bytes send_d "channel_send\n2\n"
bytes send_f "call\n%__async_test\nchannel_write_wait\n2\n"
bytes newline "\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: async lowering rejected token stream\n"

func next 3
arg %fd 0
arg %buffer 1
arg %capacity 2
u64 %zero 0
u64 %one 1
u64 %lf 10
u64 %length 0
label read
eq %test %length %capacity
nonzero %test full
add %seat %buffer %length
read %count %fd %seat %one
slt %test %count %zero
nonzero %test full
zero %count done
load8 %byte %seat %zero
eq %test %byte %lf
nonzero %test done
add %length %length %one
jump read
label done
ret %length
label full
ret %capacity
end

func same 4
arg %left 0
arg %llen 1
arg %right 2
arg %rlen 3
u64 %zero 0
u64 %one 1
ne %test %llen %rlen
nonzero %test no
u64 %index 0
label byte
eq %test %index %llen
nonzero %test yes
load8 %a %left %index
load8 %b %right %index
ne %test %a %b
nonzero %test no
add %index %index %one
jump byte
label yes
ret %one
label no
ret %zero
end

func decimal 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %ten 10
u64 %ascii 48
u64 %nine 57
u64 %unknown 255
u64 %index 0
u64 %result 0
zero %length bad
label digit
eq %test %index %length
nonzero %test done
load8 %byte %token %index
le %test %ascii %byte
zero %test bad
le %test %byte %nine
zero %test bad
mul %result %result %ten
sub %byte %byte %ascii
add %result %result %byte
add %index %index %one
jump digit
label done
ret %result
label bad
ret %unknown
end

func put 2
arg %data 0
arg %length 1
u64 %fd 1
write %result %fd %data %length
ret %result
end

func emit 2
arg %data 0
arg %length 1
u64 %one 1
call %wrote put 2 %data %length
out newline
ret %one
end

func copy 3
arg %target 0
arg %source 1
arg %length 2
u64 %zero 0
u64 %one 1
u64 %max 63
le %test %length %max
zero %test bad
u64 %index 0
label byte
eq %test %index %length
nonzero %test done
load8 %value %source %index
store8 %target %index %value
add %index %index %one
jump byte
label done
ret %one
label bad
ret %zero
end

func nextcopy 4
arg %buffer 0
arg %capacity 1
arg %target 2
arg %target_capacity 3
u64 %zero 0
u64 %fd 0
call %length next 3 %fd %buffer %capacity
zero %length bad
le %test %target_capacity %length
nonzero %test bad
call %test copy 3 %target %buffer %length
zero %test bad
ret %length
label bad
ret %zero
end

func item 3
arg %wanted 0
arg %table 1
arg %size 2
u64 %zero 0
u64 %one 1
u64 %lf 10
u64 %index 0
u64 %line 0
u64 %start 0
label seek
le %test %size %index
nonzero %test bad
eq %test %line %wanted
nonzero %test width
load8 %byte %table %index
eq %test %byte %lf
zero %test next
add %line %line %one
add %start %index %one
label next
add %index %index %one
jump seek
label width
load8 %byte %table %index
eq %test %byte %lf
nonzero %test done
add %index %index %one
le %test %size %index
nonzero %test bad
jump width
label done
sub %length %index %start
add %data %table %start
call %wrote emit 2 %data %length
ret %one
label bad
ret %zero
end

func main 0
u64 %zero 0
u64 %one 1
u64 %limit 8
u64 %unknown 255
u64 %capacity 4096
u64 %small 64
u64 %fd 0
u64 %state_count 0
u64 %await_index 0
alloc %buffer %capacity
alloc %a %small
alloc %b %small
alloc %c %small
alloc %d %small
alloc %e %small
zero %buffer limited
zero %a limited
zero %b limited
zero %c limited
zero %d limited
zero %e limited
label token
call %length next 3 %fd %buffer %capacity
zero %length success
eq %test %length %capacity
nonzero %test invalid
data %word %wordlen asyncword
call %test same 4 %buffer %length %word %wordlen
nonzero %test async
data %word %wordlen stateword
call %test same 4 %buffer %length %word %wordlen
nonzero %test state
data %word %wordlen awaitword
call %test same 4 %buffer %length %word %wordlen
nonzero %test await
data %word %wordlen sendawaitword
call %test same 4 %buffer %length %word %wordlen
nonzero %test sendawait
call %wrote emit 2 %buffer %length
jump token
label async
call %alen nextcopy 4 %buffer %capacity %a %small
call %blen nextcopy 4 %buffer %capacity %b %small
call %clen nextcopy 4 %buffer %capacity %c %small
zero %alen invalid
zero %blen invalid
zero %clen invalid
ne %test %clen %one
nonzero %test invalid
call %state_count decimal 2 %c %clen
eq %test %state_count %unknown
nonzero %test invalid
zero %state_count invalid
le %test %state_count %limit
zero %test invalid
u64 %await_index 0
out async_a
call %wrote emit 2 %b %blen
out async_b
call %wrote emit 2 %a %alen
out async_c
u64 %index 0
label dispatch
eq %test %index %state_count
nonzero %test dispatch_done
out dispatch_a
data %table %tablesize numbers
call %test item 3 %index %table %tablesize
zero %test invalid
out dispatch_b
data %table %tablesize states
call %test item 3 %index %table %tablesize
zero %test invalid
add %index %index %one
jump dispatch
label dispatch_done
out dispatch_end
jump token
label state
call %alen nextcopy 4 %buffer %capacity %a %small
zero %alen invalid
ne %test %alen %one
nonzero %test invalid
call %value decimal 2 %a %alen
eq %test %value %unknown
nonzero %test invalid
le %test %state_count %value
nonzero %test invalid
out labelword
data %table %tablesize states
call %test item 3 %value %table %tablesize
zero %test invalid
jump token
label await
call %alen nextcopy 4 %buffer %capacity %a %small
call %blen nextcopy 4 %buffer %capacity %b %small
call %clen nextcopy 4 %buffer %capacity %c %small
call %dlen nextcopy 4 %buffer %capacity %d %small
call %elen nextcopy 4 %buffer %capacity %e %small
zero %alen invalid
zero %blen invalid
zero %clen invalid
zero %dlen invalid
zero %elen invalid
ne %test %elen %one
nonzero %test invalid
call %value decimal 2 %e %elen
eq %test %value %unknown
nonzero %test invalid
le %test %state_count %value
nonzero %test invalid
le %test %limit %await_index
nonzero %test invalid
out await_a
data %table %tablesize numbers
call %test item 3 %value %table %tablesize
zero %test invalid
out await_b
call %wrote emit 2 %d %dlen
out await_c
call %wrote emit 2 %a %alen
out await_d
call %wrote emit 2 %b %blen
call %wrote emit 2 %c %clen
out await_e
call %wrote emit 2 %a %alen
data %table %tablesize ready
call %test item 3 %await_index %table %tablesize
zero %test invalid
out await_f
call %wrote emit 2 %b %blen
call %wrote emit 2 %d %dlen
out await_g
data %table %tablesize waiting
call %test item 3 %await_index %table %tablesize
zero %test invalid
out await_h
call %wrote emit 2 %a %alen
out await_i
data %table %tablesize ready
call %test item 3 %await_index %table %tablesize
zero %test invalid
out labelword
data %table %tablesize waiting
call %test item 3 %await_index %table %tablesize
zero %test invalid
out await_j
data %table %tablesize ready
call %test item 3 %await_index %table %tablesize
zero %test invalid
add %await_index %await_index %one
jump token
label sendawait
call %alen nextcopy 4 %buffer %capacity %a %small
call %blen nextcopy 4 %buffer %capacity %b %small
call %clen nextcopy 4 %buffer %capacity %c %small
call %dlen nextcopy 4 %buffer %capacity %d %small
call %elen nextcopy 4 %buffer %capacity %e %small
zero %alen invalid
zero %blen invalid
zero %clen invalid
zero %dlen invalid
zero %elen invalid
ne %test %elen %one
nonzero %test invalid
call %value decimal 2 %e %elen
eq %test %value %unknown
nonzero %test invalid
le %test %state_count %value
nonzero %test invalid
le %test %limit %await_index
nonzero %test invalid
out await_a
data %table %tablesize numbers
call %test item 3 %value %table %tablesize
zero %test invalid
out await_b
call %wrote emit 2 %d %dlen
out await_c
call %wrote emit 2 %a %alen
out send_d
call %wrote emit 2 %b %blen
call %wrote emit 2 %c %clen
out await_e
call %wrote emit 2 %a %alen
data %table %tablesize ready
call %test item 3 %await_index %table %tablesize
zero %test invalid
out send_f
call %wrote emit 2 %b %blen
call %wrote emit 2 %d %dlen
out await_g
data %table %tablesize waiting
call %test item 3 %await_index %table %tablesize
zero %test invalid
out await_h
call %wrote emit 2 %a %alen
out await_i
data %table %tablesize ready
call %test item 3 %await_index %table %tablesize
zero %test invalid
out labelword
data %table %tablesize waiting
call %test item 3 %await_index %table %tablesize
zero %test invalid
out await_j
data %table %tablesize ready
call %test item 3 %await_index %table %tablesize
zero %test invalid
add %await_index %await_index %one
jump token
label success
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
