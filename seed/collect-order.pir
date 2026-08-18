memory 16777216

func channel_recv 2
u64 %closed 2
ret %closed
end

func channel_wait 2
u64 %one 1
ret %one
end

func ordered 3
arg %task 0
arg %channel 1
arg %collector 2
@async %task 8 1
@state 0
@stream.collect %status %channel %collector %task 0
ret %status
end

func main 0
exit 0
end
