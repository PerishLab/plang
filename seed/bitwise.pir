memory 4096
bytes ok "bitwise ok\n"
bytes invalid "plang0: bitwise contract failed\n"

func main 0
u64 %twelve 12
u64 %ten 10
u64 %expected 8
and %value %twelve %ten
ne %test %value %expected
nonzero %test bad
u64 %expected 14
or %value %twelve %ten
ne %test %value %expected
nonzero %test bad
u64 %expected 6
xor %value %twelve %ten
ne %test %value %expected
nonzero %test bad
u64 %value 3
u64 %amount 4
shl %value %value %amount
u64 %expected 48
ne %test %value %expected
nonzero %test bad
shr %value %value %amount
u64 %expected 3
ne %test %value %expected
nonzero %test bad
out ok
exit 0
label bad
err invalid
exit 1
end
