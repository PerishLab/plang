memory 4096
bytes ok "capability ok\n"
bytes bad "capability failed\n"

func sum8 8
arg %a 0
arg %b 1
arg %c 2
arg %d 3
arg %e 4
arg %f 5
arg %g 6
arg %h 7
add %ab %a %b
add %cd %c %d
add %ef %e %f
add %gh %g %h
add %abcd %ab %cd
add %efgh %ef %gh
add %result %abcd %efgh
ret %result
end

func main 0
u64 %one 1
u64 %two 2
u64 %three 3
u64 %four 4
u64 %five 5
u64 %six 6
u64 %seven 7
u64 %eight 8
u64 %expected 36
u64 %max 18446744073709551615
add %wrapped %max %one
nonzero %wrapped failed
call %direct sum8 8 %one %two %three %four %five %six %seven %eight
ne %test %direct %expected
nonzero %test failed
funcptr %sum sum8
invoke %indirect %sum 8 %one %two %three %four %five %six %seven %eight
ne %test %indirect %expected
nonzero %test failed
out ok
exit 0
label failed
err bad
exit 1
end
