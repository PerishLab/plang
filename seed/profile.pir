memory 4096
bytes ok "profile ok\n"
bytes invalid "plang0: profile contract failed\n"

func main 0
u64 %zero 0
u64 %one 1
u64 %capacity 4096
alloc %first %capacity
zero %first bad
alloc %second %one
nonzero %second bad
out ok
exit 0
label bad
err invalid
exit 1
end
