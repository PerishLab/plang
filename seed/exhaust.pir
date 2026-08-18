memory 16777216
bytes impossible "unreachable\n"
bytes limit "plang: memory limit\n"

func main 0
u64 %r8 16777217
alloc %r16 %r8
zero %r16 failed
out impossible
exit 0
label failed
err limit
exit 1
end
