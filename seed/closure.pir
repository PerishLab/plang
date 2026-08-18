memory 4096
bytes ok "closure ok\n"
bytes limited "closure memory limit\n"
bytes invalid "closure invalid\n"

func add_captured 2
arg %context 0
arg %value 1
u64 %zero 0
load64 %captured %context %zero
add %result %captured %value
ret %result
end

func main 0
u64 %zero 0
u64 %one 1
u64 %word_at 8
u64 %record_size 16
u64 %remainder_size 4048
u64 %initial_value 40
u64 %captured_value 41
u64 %expected 42

alloc %context %record_size
alloc %closure %record_size
alloc %copy %record_size
zero %context limited
zero %closure limited
zero %copy limited

store64 %context %zero %initial_value
funcptr %code add_captured
store64 %closure %zero %code
store64 %closure %word_at %context

# A closure copy aliases its explicitly caller-owned context.
load64 %word %closure %zero
store64 %copy %zero %word
load64 %word %closure %word_at
store64 %copy %word_at %word

store64 %context %zero %captured_value

load64 %code %copy %zero
load64 %context %copy %word_at
invoke %result %code 2 %context %one
eq %test %result %expected
zero %test invalid

# Three aligned records consume 48 bytes; the exact remainder succeeds and the
# next aligned allocation fails explicitly.
alloc %remainder %remainder_size
zero %remainder limited
alloc %overflow %one
nonzero %overflow invalid

out ok
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
