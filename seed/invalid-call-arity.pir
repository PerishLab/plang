memory 4096

func one 1
arg %value 0
ret %value
end

func main 0
u64 %value 1
call %result one 0
ret %result
end
