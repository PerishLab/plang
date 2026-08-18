func imported_answer 0
u64 %answer 42
ret %answer
end

func imported_send 2
arg %channel 0
arg %value 1
@channel.send %status %channel %value
ret %status
end
