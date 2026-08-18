memory 4096
bytes ok "utf8 decode ok\n"
bytes bad "utf8 decode failed\n"

# state = {remaining, scalar, minimum, value}, four u64 fields.
# Feed consumes exactly one byte and returns channel-shaped status:
# 0=pending, 1=value, 3=failed. A failure resets remaining to zero.
func utf8_decode_feed 2
arg %state 0
arg %byte 1
u64 %zero 0
u64 %one 1
u64 %pending 0
u64 %value_status 1
u64 %failed 3
u64 %scalar_at 8
u64 %minimum_at 16
u64 %value_at 24
u64 %mask 63
load64 %remaining %state %zero
nonzero %remaining continuation
u64 %bound 127
le %test %byte %bound
nonzero %test ascii
u64 %low 194
le %test %low %byte
zero %test invalid
u64 %high 223
le %test %byte %high
nonzero %test lead2
u64 %low 224
le %test %low %byte
zero %test invalid
u64 %high 239
le %test %byte %high
nonzero %test lead3
u64 %low 240
le %test %low %byte
zero %test invalid
u64 %high 244
le %test %byte %high
zero %test invalid
u64 %remaining 3
u64 %headmask 7
and %scalar %byte %headmask
u64 %minimum 65536
jump begin
label lead3
u64 %remaining 2
u64 %headmask 15
and %scalar %byte %headmask
u64 %minimum 2048
jump begin
label lead2
u64 %remaining 1
u64 %headmask 31
and %scalar %byte %headmask
u64 %minimum 128
label begin
store64 %state %zero %remaining
store64 %state %scalar_at %scalar
store64 %state %minimum_at %minimum
ret %pending
label ascii
store64 %state %value_at %byte
ret %value_status
label continuation
u64 %low 128
le %test %low %byte
zero %test invalid
u64 %high 191
le %test %byte %high
zero %test invalid
load64 %scalar %state %scalar_at
u64 %shift 6
shl %scalar %scalar %shift
and %byte %byte %mask
or %scalar %scalar %byte
sub %remaining %remaining %one
store64 %state %zero %remaining
store64 %state %scalar_at %scalar
nonzero %remaining pending_value
load64 %minimum %state %minimum_at
le %test %minimum %scalar
zero %test invalid
u64 %low 55296
lt %test %scalar %low
nonzero %test scalar_valid
u64 %high 57343
le %test %scalar %high
nonzero %test invalid
label scalar_valid
u64 %high 1114111
le %test %scalar %high
zero %test invalid
store64 %state %value_at %scalar
ret %value_status
label pending_value
ret %pending
label invalid
store64 %state %zero %zero
ret %failed
end

# Map an upstream terminal into the same four-state result.
# A clean close with no partial scalar stays closed; every other terminal or
# truncated sequence is failed. Failure resets the partial sequence.
func utf8_decode_terminal 2
arg %state 0
arg %terminal 1
u64 %zero 0
u64 %closed 2
u64 %failed 3
ne %test %terminal %closed
nonzero %test failure
load64 %remaining %state %zero
nonzero %remaining failure
ret %closed
label failure
store64 %state %zero %zero
ret %failed
end

func main 0
u64 %zero 0
u64 %pending 0
u64 %value_status 1
u64 %closed 2
u64 %failed_status 3
u64 %value_at 24
u64 %statesize 32
alloc %state %statesize
zero %state failed
store64 %state %zero %zero

# ASCII.
u64 %byte 65
call %status utf8_decode_feed 2 %state %byte
ne %test %status %value_status
nonzero %test failed
load64 %value %state %value_at
ne %test %value %byte
nonzero %test failed

# U+03BB: CE BB.
u64 %byte 206
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
u64 %byte 187
call %status utf8_decode_feed 2 %state %byte
ne %test %status %value_status
nonzero %test failed
load64 %value %state %value_at
u64 %expected 955
ne %test %value %expected
nonzero %test failed

# U+4F60: E4 BD A0.
u64 %byte 228
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
u64 %byte 189
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
u64 %byte 160
call %status utf8_decode_feed 2 %state %byte
ne %test %status %value_status
nonzero %test failed
load64 %value %state %value_at
u64 %expected 20320
ne %test %value %expected
nonzero %test failed

# U+1F600: F0 9F 98 80.
u64 %byte 240
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
u64 %byte 159
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
u64 %byte 152
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
u64 %byte 128
call %status utf8_decode_feed 2 %state %byte
ne %test %status %value_status
nonzero %test failed
load64 %value %state %value_at
u64 %expected 128512
ne %test %value %expected
nonzero %test failed

# Invalid continuation resets the partial sequence.
u64 %byte 194
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
u64 %byte 65
call %status utf8_decode_feed 2 %state %byte
ne %test %status %failed_status
nonzero %test failed

# Overlong E0 80 80.
u64 %byte 224
call %status utf8_decode_feed 2 %state %byte
u64 %byte 128
call %status utf8_decode_feed 2 %state %byte
call %status utf8_decode_feed 2 %state %byte
ne %test %status %failed_status
nonzero %test failed

# Surrogate ED A0 80.
u64 %byte 237
call %status utf8_decode_feed 2 %state %byte
u64 %byte 160
call %status utf8_decode_feed 2 %state %byte
u64 %byte 128
call %status utf8_decode_feed 2 %state %byte
ne %test %status %failed_status
nonzero %test failed

# Above U+10FFFF: F4 90 80 80.
u64 %byte 244
call %status utf8_decode_feed 2 %state %byte
u64 %byte 144
call %status utf8_decode_feed 2 %state %byte
u64 %byte 128
call %status utf8_decode_feed 2 %state %byte
call %status utf8_decode_feed 2 %state %byte
ne %test %status %failed_status
nonzero %test failed

# Invalid lead C0.
u64 %byte 192
call %status utf8_decode_feed 2 %state %byte
ne %test %status %failed_status
nonzero %test failed

# Clean close and truncated close.
call %status utf8_decode_terminal 2 %state %closed
ne %test %status %closed
nonzero %test failed
u64 %byte 226
call %status utf8_decode_feed 2 %state %byte
ne %test %status %pending
nonzero %test failed
call %status utf8_decode_terminal 2 %state %closed
ne %test %status %failed_status
nonzero %test failed
call %status utf8_decode_terminal 2 %state %failed_status
ne %test %status %failed_status
nonzero %test failed

out ok
exit 0
label failed
err bad
exit 1
end
