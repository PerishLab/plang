memory 4096

func channel_send 2
u64 %accepted 1
ret %accepted
end

func main 0
u64 %channel 0
u64 %value 7
u64 %accepted 1
u64 %expected 42
call %actual imported_answer 0
eq %ok %actual %expected
zero %ok failed
call %status imported_send 2 %channel %value
eq %ok %status %accepted
zero %ok failed
exit 0
label failed
exit 1
end
