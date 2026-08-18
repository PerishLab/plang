memory 4096
bytes ok "\nutf8 ok\n"
bytes bad "utf8 failed\n"

# Encode one Unicode scalar into a caller-owned byte buffer.
# state[0] is the committed byte length. Status is explicit:
# 1=encoded, 2=invalid scalar, 3=capacity.
func utf8_encode 4
arg %buffer 0
arg %capacity 1
arg %state 2
arg %scalar 3
u64 %zero 0
u64 %one 1
u64 %valid 1
u64 %invalid 2
u64 %full 3
u64 %mask 63
load64 %length %state %zero
u64 %bound 127
le %test %scalar %bound
nonzero %test width1
u64 %bound 2047
le %test %scalar %bound
nonzero %test width2
u64 %bound 65535
le %test %scalar %bound
zero %test width4_check
u64 %low 55296
lt %test %scalar %low
nonzero %test width3
u64 %high 57343
le %test %scalar %high
nonzero %test invalid_scalar
jump width3
label width4_check
u64 %bound 1114111
le %test %scalar %bound
zero %test invalid_scalar
u64 %width 4
jump capacity_check
label width3
u64 %width 3
jump capacity_check
label width2
u64 %width 2
jump capacity_check
label width1
u64 %width 1
label capacity_check
add %end %length %width
le %test %end %capacity
zero %test capacity_full
eq %test %width %one
nonzero %test emit1
u64 %value 2
eq %test %width %value
nonzero %test emit2
u64 %value 3
eq %test %width %value
nonzero %test emit3
u64 %shift 18
shr %byte %scalar %shift
u64 %head 240
or %byte %byte %head
store8 %buffer %length %byte
add %length %length %one
u64 %shift 12
shr %byte %scalar %shift
and %byte %byte %mask
u64 %head 128
or %byte %byte %head
store8 %buffer %length %byte
add %length %length %one
jump emit2_tail
label emit3
u64 %shift 12
shr %byte %scalar %shift
u64 %head 224
or %byte %byte %head
store8 %buffer %length %byte
add %length %length %one
label emit2_tail
u64 %shift 6
shr %byte %scalar %shift
and %byte %byte %mask
u64 %head 128
or %byte %byte %head
store8 %buffer %length %byte
add %length %length %one
jump emit1_tail
label emit2
u64 %shift 6
shr %byte %scalar %shift
u64 %head 192
or %byte %byte %head
store8 %buffer %length %byte
add %length %length %one
label emit1_tail
and %byte %scalar %mask
u64 %head 128
or %byte %byte %head
store8 %buffer %length %byte
jump commit
label emit1
store8 %buffer %length %scalar
label commit
store64 %state %zero %end
ret %valid
label invalid_scalar
ret %invalid
label capacity_full
ret %full
end

func main 0
u64 %zero 0
u64 %one 1
u64 %invalid 2
u64 %full 3
u64 %capacity 16
u64 %statesize 8
alloc %buffer %capacity
alloc %state %statesize
zero %buffer failed
zero %state failed
store64 %state %zero %zero
u64 %scalar 65
call %status utf8_encode 4 %buffer %capacity %state %scalar
ne %test %status %one
nonzero %test failed
u64 %scalar 955
call %status utf8_encode 4 %buffer %capacity %state %scalar
ne %test %status %one
nonzero %test failed
u64 %scalar 20320
call %status utf8_encode 4 %buffer %capacity %state %scalar
ne %test %status %one
nonzero %test failed
u64 %scalar 128512
call %status utf8_encode 4 %buffer %capacity %state %scalar
ne %test %status %one
nonzero %test failed
load64 %length %state %zero
u64 %expected 10
ne %test %length %expected
nonzero %test failed
u64 %scalar 55296
call %status utf8_encode 4 %buffer %capacity %state %scalar
ne %test %status %invalid
nonzero %test failed
u64 %scalar 1114112
call %status utf8_encode 4 %buffer %capacity %state %scalar
ne %test %status %invalid
nonzero %test failed
u64 %tight 13
u64 %scalar 128512
call %status utf8_encode 4 %buffer %tight %state %scalar
ne %test %status %full
nonzero %test failed
load64 %length %state %zero
ne %test %length %expected
nonzero %test failed
u64 %fd 1
write %wrote %fd %buffer %length
ne %test %wrote %length
nonzero %test failed
out ok
exit 0
label failed
err bad
exit 1
end
