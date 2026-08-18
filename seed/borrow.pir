memory 8192
bytes openword "@borrow.mut"
bytes closeword "@borrow.end"
bytes awaitword "@borrow.await.recv"
bytes recvword "@await.recv"
bytes sendword "@await.send"
bytes collectword "@stream.collect"
bytes loweredawait "@await.recv\n"
bytes funcword "func"
bytes endword "end"
bytes newline "\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: borrow lowering rejected token stream\n"

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

func seat 3
arg %records 0
arg %index 1
arg %size 2
mul %offset %index %size
add %record %records %offset
ret %record
end

func main 0
u64 %zero 0
u64 %one 1
u64 %capacity 4096
u64 %small 64
u64 %record_size 72
u64 %length_at 64
u64 %record_count 8
u64 %records_size 576
u64 %fd 0
u64 %inside 0
u64 %live 0
alloc %buffer %capacity
alloc %operand %small
alloc %records %records_size
zero %buffer limited
zero %operand limited
zero %records limited
label token
call %length next 3 %fd %buffer %capacity
zero %length finish
eq %test %length %capacity
nonzero %test invalid
data %word %wordlen openword
call %test same 4 %buffer %length %word %wordlen
nonzero %test open
data %word %wordlen closeword
call %test same 4 %buffer %length %word %wordlen
nonzero %test close
data %word %wordlen awaitword
call %test same 4 %buffer %length %word %wordlen
nonzero %test await
data %word %wordlen recvword
call %test same 4 %buffer %length %word %wordlen
nonzero %test suspension
data %word %wordlen sendword
call %test same 4 %buffer %length %word %wordlen
nonzero %test suspension
data %word %wordlen collectword
call %test same 4 %buffer %length %word %wordlen
nonzero %test suspension
data %word %wordlen funcword
call %test same 4 %buffer %length %word %wordlen
nonzero %test function
data %word %wordlen endword
call %test same 4 %buffer %length %word %wordlen
nonzero %test function_end
call %wrote emit 2 %buffer %length
jump token

label function
nonzero %inside invalid
nonzero %live invalid
u64 %inside 1
call %wrote emit 2 %buffer %length
jump token

label function_end
zero %inside invalid
nonzero %live invalid
u64 %inside 0
call %wrote emit 2 %buffer %length
jump token

label open
zero %inside invalid
call %operand_length nextcopy 4 %buffer %capacity %operand %small
zero %operand_length invalid
eq %test %live %record_count
nonzero %test invalid
u64 %index 0
label duplicate
eq %test %index %live
nonzero %test remember
call %record seat 3 %records %index %record_size
load64 %known_length %record %length_at
call %test same 4 %operand %operand_length %record %known_length
nonzero %test invalid
add %index %index %one
jump duplicate
label remember
call %record seat 3 %records %live %record_size
call %test copy 3 %record %operand %operand_length
zero %test invalid
store64 %record %length_at %operand_length
add %live %live %one
jump token

label close
zero %inside invalid
call %operand_length nextcopy 4 %buffer %capacity %operand %small
zero %operand_length invalid
zero %live invalid
sub %index %live %one
call %record seat 3 %records %index %record_size
load64 %known_length %record %length_at
call %test same 4 %operand %operand_length %record %known_length
zero %test invalid
add %live %index %zero
jump token

label await
zero %inside invalid
nonzero %live invalid
out loweredawait
u64 %index 0
u64 %operand_count 5
label await_operand
eq %test %index %operand_count
nonzero %test token
call %operand_length nextcopy 4 %buffer %capacity %operand %small
zero %operand_length invalid
call %wrote emit 2 %operand %operand_length
add %index %index %one
jump await_operand

label suspension
zero %inside invalid
nonzero %live invalid
call %wrote emit 2 %buffer %length
jump token

label finish
nonzero %inside invalid
nonzero %live invalid
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
