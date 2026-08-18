memory 16777216
bytes asyncword "@async"
bytes collectword "@stream.collect"
bytes loops "__collect_loop_0\n__collect_loop_1\n__collect_loop_2\n__collect_loop_3\n__collect_loop_4\n__collect_loop_5\n__collect_loop_6\n__collect_loop_7\n"
bytes values "__collect_value_0\n__collect_value_1\n__collect_value_2\n__collect_value_3\n__collect_value_4\n__collect_value_5\n__collect_value_6\n__collect_value_7\n"
bytes fulls "__collect_full_0\n__collect_full_1\n__collect_full_2\n__collect_full_3\n__collect_full_4\n__collect_full_5\n__collect_full_6\n__collect_full_7\n"
bytes dones "__collect_done_0\n__collect_done_1\n__collect_done_2\n__collect_done_3\n__collect_done_4\n__collect_done_5\n__collect_done_6\n__collect_done_7\n"
bytes labelword "label\n"
bytes jumpword "jump\n"
bytes a "u64\n%__collect_offset\n24\nadd\n%__collect_target\n"
bytes b "%__collect_offset\n@await.recv\n"
bytes c "%__collect_target\n"
bytes d "u64\n%__collect_one\n1\neq\n%__collect_test\n"
bytes e "%__collect_one\nnonzero\n%__collect_test\n"
bytes f "u64\n%__collect_offset\n8\nload64\n%__collect_capacity\n"
bytes g "%__collect_offset\nu64\n%__collect_offset\n16\nload64\n%__collect_length\n"
bytes h "%__collect_offset\nle\n%__collect_test\n%__collect_capacity\n%__collect_length\nnonzero\n%__collect_test\n"
bytes i "u64\n%__collect_offset\n0\nload64\n%__collect_buffer\n"
bytes j "%__collect_offset\nload8\n%__collect_byte\n%__collect_target\n%__collect_offset\nstore8\n%__collect_buffer\n%__collect_length\n%__collect_byte\nadd\n%__collect_length\n%__collect_length\n%__collect_one\nu64\n%__collect_offset\n16\nstore64\n"
bytes k "%__collect_offset\n%__collect_length\njump\n"
bytes setstatus "u64\n"
bytes fullstatus "4\n"
bytes newline "\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: collect lowering rejected token stream\n"

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
u64 %seven 7
u64 %limit 8
u64 %unknown 255
u64 %capacity 4096
u64 %small 64
u64 %fd 0
u64 %collect_index 0
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
nonzero %test frame
data %word %wordlen collectword
call %test same 4 %buffer %length %word %wordlen
nonzero %test collect
call %wrote emit 2 %buffer %length
jump token
label frame
u64 %collect_index 0
call %wrote emit 2 %buffer %length
jump token
label collect
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
call %resume decimal 2 %e %elen
eq %test %resume %unknown
nonzero %test invalid
le %test %resume %seven
zero %test invalid
le %test %limit %collect_index
nonzero %test invalid
out labelword
data %table %tablesize loops
call %test item 3 %collect_index %table %tablesize
zero %test invalid
out a
call %wrote emit 2 %c %clen
out b
call %wrote emit 2 %a %alen
call %wrote emit 2 %b %blen
out c
call %wrote emit 2 %d %dlen
call %wrote emit 2 %e %elen
out d
call %wrote emit 2 %a %alen
out e
data %table %tablesize values
call %test item 3 %collect_index %table %tablesize
zero %test invalid
out jumpword
data %table %tablesize dones
call %test item 3 %collect_index %table %tablesize
zero %test invalid
out labelword
data %table %tablesize values
call %test item 3 %collect_index %table %tablesize
zero %test invalid
out f
call %wrote emit 2 %c %clen
out g
call %wrote emit 2 %c %clen
out h
data %table %tablesize fulls
call %test item 3 %collect_index %table %tablesize
zero %test invalid
out i
call %wrote emit 2 %c %clen
out j
call %wrote emit 2 %c %clen
out k
data %table %tablesize loops
call %test item 3 %collect_index %table %tablesize
zero %test invalid
out labelword
data %table %tablesize fulls
call %test item 3 %collect_index %table %tablesize
zero %test invalid
out setstatus
call %wrote emit 2 %a %alen
out fullstatus
out labelword
data %table %tablesize dones
call %test item 3 %collect_index %table %tablesize
zero %test invalid
add %collect_index %collect_index %one
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
