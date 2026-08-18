memory 8192
bytes sendword "@channel.send"
bytes callword "call\n"
bytes functionword "channel_send\n"
bytes arity "2\n"
bytes newline "\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: send lowering rejected token stream\n"

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

func main 0
u64 %zero 0
u64 %capacity 4096
u64 %small 64
u64 %fd 0
alloc %buffer %capacity
alloc %status %small
alloc %channel %small
alloc %value %small
zero %buffer limited
zero %status limited
zero %channel limited
zero %value limited
label token
call %length next 3 %fd %buffer %capacity
zero %length success
eq %test %length %capacity
nonzero %test invalid
data %word %wordlen sendword
call %test same 4 %buffer %length %word %wordlen
nonzero %test send
call %wrote emit 2 %buffer %length
jump token
label send
call %alen nextcopy 4 %buffer %capacity %status %small
call %blen nextcopy 4 %buffer %capacity %channel %small
call %clen nextcopy 4 %buffer %capacity %value %small
zero %alen invalid
zero %blen invalid
zero %clen invalid
out callword
call %wrote emit 2 %status %alen
out functionword
out arity
call %wrote emit 2 %channel %blen
call %wrote emit 2 %value %clen
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
