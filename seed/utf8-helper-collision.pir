memory 4096

func channel_recv 2
u64 %closed 2
ret %closed
end

func __utf8_stream_recv 2
u64 %zero 0
ret %zero
end

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
