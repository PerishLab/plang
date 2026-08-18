memory 16777216
bytes message "hello, plang\n"
bytes limit "plang: memory limit\n"

func main 0
u64 %size 64
alloc %data %size
zero %data failed
out message
exit 0
label failed
err limit
exit 1
end
