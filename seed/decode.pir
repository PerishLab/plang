memory 16777216
bytes top "memory 1\nbytes 2\nfunc 2\n"
bytes body "arg 2\nu64 2\ndata 3\nfuncptr 2\nadd 3\nsub 3\nmul 3\nand 3\nor 3\nxor 3\nshl 3\nshr 3\neq 3\nne 3\nlt 3\nle 3\nslt 3\nload8 3\nload64 3\nstore8 3\nstore64 3\nalloc 2\nargv 3\nread 4\nwrite 4\nopen 2\nclose 2\ncall 9\ninvoke 9\nlabel 1\njump 1\nzero 2\nnonzero 2\nout 1\nerr 1\nexit 1\nret 1\nend 0\n"
bytes funcword "func"
bytes endword "end"
bytes ok "decode ok\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: invalid token stream\n"

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
u64 %result 1
ret %result
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
u64 %ascii 48
u64 %unknown 255
u64 %index 0
label record
le %test %size %index
nonzero %test missing
add %start %index %zero
label name
load8 %byte %table %index
eq %test %byte %space
nonzero %test arity
add %index %index %one
le %test %size %index
nonzero %test missing
jump name
label arity
sub %width %index %start
add %name %table %start
call %test same 4 %token %length %name %width
add %index %index %one
load8 %arity %table %index
sub %arity %arity %ascii
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
ret %arity
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

func skip 4
arg %fd 0
arg %buffer 1
arg %capacity 2
arg %count 3
u64 %zero 0
u64 %one 1
u64 %index 0
label token
eq %test %index %count
nonzero %test yes
call %length next 3 %fd %buffer %capacity
zero %length no
eq %test %length %capacity
nonzero %test no
add %index %index %one
jump token
label yes
ret %one
label no
ret %zero
end

func main 0
u64 %zero 0
u64 %one 1
u64 %nine 9
u64 %unknown 255
u64 %capacity 4096
u64 %fd 0
u64 %inside 0
alloc %buffer %capacity
zero %buffer limited
data %top %toplen top
data %body %bodylen body
data %funcword %funclen funcword
data %endword %endlen endword
label token
call %length next 3 %fd %buffer %capacity
zero %length finish
eq %test %length %capacity
nonzero %test invalid
zero %inside outside
call %arity lookup 4 %buffer %length %body %bodylen
eq %test %arity %unknown
nonzero %test invalid
eq %test %arity %nine
nonzero %test dynamic
call %test same 4 %buffer %length %endword %endlen
zero %test fixed
u64 %inside 0
jump token
label fixed
call %test skip 4 %fd %buffer %capacity %arity
zero %test invalid
jump token
label dynamic
u64 %two 2
call %test skip 4 %fd %buffer %capacity %two
zero %test invalid
call %length next 3 %fd %buffer %capacity
zero %length invalid
call %arity decimal 2 %buffer %length
eq %test %arity %unknown
nonzero %test invalid
call %test skip 4 %fd %buffer %capacity %arity
zero %test invalid
jump token
label outside
call %arity lookup 4 %buffer %length %top %toplen
eq %test %arity %unknown
nonzero %test invalid
call %test same 4 %buffer %length %funcword %funclen
zero %test topfixed
u64 %inside 1
label topfixed
call %test skip 4 %fd %buffer %capacity %arity
zero %test invalid
jump token
label finish
nonzero %inside invalid
out ok
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
