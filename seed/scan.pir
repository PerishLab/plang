memory 16777216
bytes usage "plang0: source path required\n"
bytes opened "plang0: source open failed\n"
bytes invalid "plang0: invalid source byte\n"
bytes limited "plang0: memory limit\n"
bytes failed "plang0: source read failed\n"
bytes ok "scan ok\n"

func allowed 1
arg %byte 0
u64 %tab 9
u64 %lf 10
u64 %cr 13
u64 %space 32
u64 %tilde 126
eq %a %byte %tab
eq %b %byte %lf
or %a %a %b
eq %b %byte %cr
or %a %a %b
le %b %space %byte
le %c %byte %tilde
and %b %b %c
or %a %a %b
ret %a
end

func main 2
arg %argc 0
arg %argv 1
u64 %zero 0
u64 %one 1
u64 %two 2
lt %test %argc %two
nonzero %test usage
argv %path %argv %one
open %fd %path
slt %test %fd %zero
nonzero %test opened
u64 %capacity 4096
alloc %buffer %capacity
zero %buffer limited
label read
read %count %fd %buffer %capacity
slt %test %count %zero
nonzero %test failed
zero %count success
u64 %index 0
label scan
eq %test %index %count
nonzero %test read
load8 %byte %buffer %index
call %test allowed 1 %byte
zero %test invalid
add %index %index %one
jump scan
label success
close %closed %fd
out ok
exit 0
label usage
err usage
exit 1
label opened
err opened
exit 1
label invalid
close %closed %fd
err invalid
exit 1
label limited
err limited
exit 1
label failed
close %closed %fd
err failed
exit 1
end
