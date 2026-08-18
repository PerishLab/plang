memory 16777216

func channel_recv 2
u64 %ready 1
ret %ready
end

func channel_wait 2
u64 %one 1
ret %one
end

func first 3
arg %task 0
arg %channel 1
arg %target 2
@async %task 8 1
@state 0
@borrow.mut %target
u64 %zero 0
load8 %observed %target %zero
@borrow.end %target
@borrow.await.recv %status %channel %target %task 0
ret %zero
end

func second 3
arg %task 0
arg %channel 1
arg %target 2
@async %task 8 1
@state 0
@borrow.await.recv %status %channel %target %task 0
u64 %zero 0
ret %zero
end

func main 0
exit 0
end
