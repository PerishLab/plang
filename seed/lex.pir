memory 16777216
bytes usage "plang0: source path required\n"
bytes opened "plang0: source open failed\n"
bytes limited "plang0: memory limit\n"
bytes failed "plang0: source read failed\n"
bytes quoted "plang0: unterminated string\n"
bytes newline "\n"

func space 1
arg %byte 0
u64 %tab 9
u64 %lf 10
u64 %cr 13
u64 %blank 32
eq %a %byte %tab
eq %b %byte %lf
or %a %a %b
eq %b %byte %cr
or %a %a %b
eq %b %byte %blank
or %a %a %b
ret %a
end

func main 2
arg %argc 0
arg %argv 1
u64 %zero 0
u64 %one 1
u64 %two 2
u64 %hash 35
u64 %mark 34
u64 %slash 92
u64 %lf 10
u64 %token 0
u64 %quote 0
u64 %escape 0
u64 %comment 0
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
zero %count finish
u64 %index 0
label byte
eq %test %index %count
nonzero %test read
load8 %value %buffer %index
nonzero %comment comment
nonzero %quote quote
eq %test %value %hash
zero %test normal
nonzero %token normal
u64 %comment 1
jump next
label comment
eq %test %value %lf
zero %test next
u64 %comment 0
jump next
label quote
add %seat %buffer %index
write %wrote %one %seat %one
zero %escape quote_slash
u64 %escape 0
jump next
label quote_slash
eq %test %value %slash
zero %test quote_end
u64 %escape 1
jump next
label quote_end
eq %test %value %mark
zero %test next
u64 %quote 0
jump next
label normal
call %test space 1 %value
zero %test mark
zero %token next
out newline
u64 %token 0
jump next
label mark
eq %test %value %mark
zero %test emit
u64 %quote 1
label emit
u64 %token 1
add %seat %buffer %index
write %wrote %one %seat %one
label next
add %index %index %one
jump byte
label finish
close %closed %fd
nonzero %quote quoted
zero %token success
out newline
label success
exit 0
label usage
err usage
exit 1
label opened
err opened
exit 1
label limited
err limited
exit 1
label failed
close %closed %fd
err failed
exit 1
label quoted
err quoted
exit 1
end
