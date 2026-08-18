memory 8192
bytes top "memory 1\nbytes 2\nfunc F\n"
bytes body "arg 2\nu64 2\ndata 3\nfuncptr 2\nadd 3\nsub 3\nmul 3\nand 3\nor 3\nxor 3\nshl 3\nshr 3\neq 3\nne 3\nlt 3\nle 3\nslt 3\nload8 3\nload64 3\nstore8 3\nstore64 3\nalloc 2\nargv 3\nread 4\nwrite 4\nopen 2\nclose 2\ncall C\ninvoke I\nlabel L\njump L\nzero Z\nnonzero Z\nout 1\nerr 1\nexit 1\nret 1\nend E\n"
bytes slots "8\n16\n24\n32\n40\n48\n56\n64\n72\n80\n88\n96\n104\n112\n120\n128\n136\n144\n152\n160\n168\n176\n184\n192\n200\n208\n216\n224\n232\n240\n"
bytes prefix "%r"
bytes join "_"
bytes newline "\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: lowering rejected token stream\n"

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

func lookup 4
arg %token 0
arg %length 1
arg %table 2
arg %size 3
u64 %zero 0
u64 %one 1
u64 %space 32
u64 %lf 10
u64 %unknown 255
u64 %index 0
label record
le %test %size %index
nonzero %test missing
add %start %index %zero
label name
load8 %byte %table %index
eq %test %byte %space
nonzero %test code
add %index %index %one
le %test %size %index
nonzero %test missing
jump name
label code
sub %width %index %start
add %name %table %start
call %test same 4 %token %length %name %width
add %index %index %one
load8 %code %table %index
nonzero %test found
label newline
load8 %byte %table %index
eq %test %byte %lf
nonzero %test advance
add %index %index %one
le %test %size %index
nonzero %test missing
jump newline
label advance
add %index %index %one
jump record
label found
ret %code
label missing
ret %unknown
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

func find 4
arg %token 0
arg %length 1
arg %records 2
arg %count 3
u64 %zero 0
u64 %one 1
u64 %stride 64
u64 %unknown 255
u64 %index 0
add %record %records %zero
label record
eq %test %index %count
nonzero %test missing
load8 %width %record %zero
add %name %record %one
call %test same 4 %token %length %name %width
nonzero %test found
add %record %record %stride
add %index %index %one
jump record
label found
ret %index
label missing
ret %unknown
end

func save 4
arg %records 0
arg %wanted 1
arg %token 2
arg %length 3
u64 %zero 0
u64 %one 1
u64 %stride 64
u64 %max 63
le %test %length %max
zero %test bad
u64 %index 0
add %record %records %zero
label seek
eq %test %index %wanted
nonzero %test copy
add %record %record %stride
add %index %index %one
jump seek
label copy
store8 %record %zero %length
add %target %record %one
call %test copy 3 %target %token %length
ret %test
label bad
ret %zero
end

func slot 1
arg %wanted 0
u64 %zero 0
u64 %one 1
u64 %lf 10
data %table %size slots
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
out prefix
call %wrote emit 2 %data %length
ret %one
label bad
ret %zero
end

func map 3
arg %token 0
arg %length 1
arg %state 2
u64 %zero 0
u64 %one 1
u64 %mark 37
u64 %limit 30
u64 %unknown 255
zero %length bad
load8 %byte %token %zero
eq %test %byte %mark
zero %test raw
load8 %count %state %zero
add %records %state %one
call %index find 4 %token %length %records %count
eq %test %index %unknown
zero %test found
le %test %limit %count
nonzero %test bad
call %test save 4 %records %count %token %length
zero %test bad
add %index %count %zero
add %count %count %one
store8 %state %zero %count
label found
call %test slot 1 %index
ret %test
label raw
call %test emit 2 %token %length
ret %test
label bad
ret %zero
end

func qualify 4
arg %function 0
arg %funclen 1
arg %label 2
arg %labellen 3
u64 %one 1
call %wrote put 2 %function %funclen
out join
call %wrote emit 2 %label %labellen
ret %one
end

func fixed 4
arg %buffer 0
arg %capacity 1
arg %count 2
arg %state 3
u64 %zero 0
u64 %one 1
u64 %fd 0
u64 %index 0
label token
eq %test %index %count
nonzero %test done
call %length next 3 %fd %buffer %capacity
zero %length bad
eq %test %length %capacity
nonzero %test bad
call %test map 3 %buffer %length %state
zero %test bad
add %index %index %one
jump token
label done
ret %one
label bad
ret %zero
end

func raw 3
arg %buffer 0
arg %capacity 1
arg %count 2
u64 %zero 0
u64 %one 1
u64 %fd 0
u64 %index 0
label token
eq %test %index %count
nonzero %test done
call %length next 3 %fd %buffer %capacity
zero %length bad
eq %test %length %capacity
nonzero %test bad
call %wrote emit 2 %buffer %length
add %index %index %one
jump token
label done
ret %one
label bad
ret %zero
end

func main 0
u64 %zero 0
u64 %one 1
u64 %ascii 48
u64 %unknown 255
u64 %capacity 4096
u64 %statecap 2048
u64 %namecap 64
u64 %fd 0
u64 %inside 0
alloc %buffer %capacity
alloc %state %statecap
alloc %function %namecap
zero %buffer limited
zero %state limited
zero %function limited
store8 %state %zero %zero
data %top %toplen top
data %body %bodylen body
label token
call %length next 3 %fd %buffer %capacity
zero %length finish
eq %test %length %capacity
nonzero %test invalid
call %wrote emit 2 %buffer %length
zero %inside outside
call %code lookup 4 %buffer %length %body %bodylen
eq %test %code %unknown
nonzero %test invalid
u64 %value 69
eq %test %code %value
nonzero %test end
u64 %value 67
eq %test %code %value
nonzero %test call
u64 %value 73
eq %test %code %value
nonzero %test invoke
u64 %value 76
eq %test %code %value
nonzero %test label
u64 %value 90
eq %test %code %value
nonzero %test branch
sub %arity %code %ascii
call %test fixed 4 %buffer %capacity %arity %state
zero %test invalid
jump token
label end
u64 %inside 0
jump token
label call
call %test fixed 4 %buffer %capacity %one %state
zero %test invalid
call %test raw 3 %buffer %capacity %one
zero %test invalid
call %length next 3 %fd %buffer %capacity
zero %length invalid
call %wrote emit 2 %buffer %length
call %arity decimal 2 %buffer %length
eq %test %arity %unknown
nonzero %test invalid
call %test fixed 4 %buffer %capacity %arity %state
zero %test invalid
jump token
label invoke
u64 %two 2
call %test fixed 4 %buffer %capacity %two %state
zero %test invalid
call %length next 3 %fd %buffer %capacity
zero %length invalid
call %wrote emit 2 %buffer %length
call %arity decimal 2 %buffer %length
eq %test %arity %unknown
nonzero %test invalid
call %test fixed 4 %buffer %capacity %arity %state
zero %test invalid
jump token
label label
call %length next 3 %fd %buffer %capacity
zero %length invalid
call %test qualify 4 %function %funclen %buffer %length
zero %test invalid
jump token
label branch
call %test fixed 4 %buffer %capacity %one %state
zero %test invalid
call %length next 3 %fd %buffer %capacity
zero %length invalid
call %test qualify 4 %function %funclen %buffer %length
zero %test invalid
jump token
label outside
call %code lookup 4 %buffer %length %top %toplen
eq %test %code %unknown
nonzero %test invalid
u64 %value 70
eq %test %code %value
nonzero %test function
sub %arity %code %ascii
call %test raw 3 %buffer %capacity %arity
zero %test invalid
jump token
label function
call %funclen next 3 %fd %buffer %capacity
zero %funclen invalid
call %wrote emit 2 %buffer %funclen
call %test copy 3 %function %buffer %funclen
zero %test invalid
call %length next 3 %fd %buffer %capacity
zero %length invalid
call %wrote emit 2 %buffer %length
call %arity decimal 2 %buffer %length
eq %test %arity %unknown
nonzero %test invalid
u64 %value 8
le %test %arity %value
zero %test invalid
store8 %state %zero %zero
u64 %inside 1
jump token
label finish
nonzero %inside invalid
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
