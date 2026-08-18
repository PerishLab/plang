memory 4096

func main 0
u64 %expected 42
call %actual imported_answer 0
eq %ok %actual %expected
zero %ok failed
exit 0
label failed
exit 1
end
