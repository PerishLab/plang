memory 4096

func main 0
u64 %zero 0
u64 %state_size 40
alloc %state %state_size
zero %state limited
@stream.utf8 %status %zero %state
exit 0
label limited
exit 1
end
