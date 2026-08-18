memory 8192
bytes marker "@stream.utf8"
bytes callword "call\n"
bytes functionword "__utf8_stream_recv\n"
bytes arity "2\n"
bytes newline "\n"
bytes helpers "func\n__utf8_decode_feed\n2\narg\n%state\n0\narg\n%byte\n1\nu64\n%zero\n0\nu64\n%one\n1\nu64\n%pending\n0\nu64\n%value_status\n1\nu64\n%failed\n3\nu64\n%scalar_at\n8\nu64\n%minimum_at\n16\nu64\n%value_at\n24\nu64\n%mask\n63\nload64\n%remaining\n%state\n%zero\nnonzero\n%remaining\ncontinuation\nu64\n%bound\n127\nle\n%test\n%byte\n%bound\nnonzero\n%test\nascii\nu64\n%low\n194\nle\n%test\n%low\n%byte\nzero\n%test\ninvalid\nu64\n%high\n223\nle\n%test\n%byte\n%high\nnonzero\n%test\nlead2\nu64\n%low\n224\nle\n%test\n%low\n%byte\nzero\n%test\ninvalid\nu64\n%high\n239\nle\n%test\n%byte\n%high\nnonzero\n%test\nlead3\nu64\n%low\n240\nle\n%test\n%low\n%byte\nzero\n%test\ninvalid\nu64\n%high\n244\nle\n%test\n%byte\n%high\nzero\n%test\ninvalid\nu64\n%remaining\n3\nu64\n%headmask\n7\nand\n%scalar\n%byte\n%headmask\nu64\n%minimum\n65536\njump\nbegin\nlabel\nlead3\nu64\n%remaining\n2\nu64\n%headmask\n15\nand\n%scalar\n%byte\n%headmask\nu64\n%minimum\n2048\njump\nbegin\nlabel\nlead2\nu64\n%remaining\n1\nu64\n%headmask\n31\nand\n%scalar\n%byte\n%headmask\nu64\n%minimum\n128\nlabel\nbegin\nstore64\n%state\n%zero\n%remaining\nstore64\n%state\n%scalar_at\n%scalar\nstore64\n%state\n%minimum_at\n%minimum\nret\n%pending\nlabel\nascii\nstore64\n%state\n%value_at\n%byte\nret\n%value_status\nlabel\ncontinuation\nu64\n%low\n128\nle\n%test\n%low\n%byte\nzero\n%test\ninvalid\nu64\n%high\n191\nle\n%test\n%byte\n%high\nzero\n%test\ninvalid\nload64\n%scalar\n%state\n%scalar_at\nu64\n%shift\n6\nshl\n%scalar\n%scalar\n%shift\nand\n%byte\n%byte\n%mask\nor\n%scalar\n%scalar\n%byte\nsub\n%remaining\n%remaining\n%one\nstore64\n%state\n%zero\n%remaining\nstore64\n%state\n%scalar_at\n%scalar\nnonzero\n%remaining\npending_value\nload64\n%minimum\n%state\n%minimum_at\nle\n%test\n%minimum\n%scalar\nzero\n%test\ninvalid\nu64\n%low\n55296\nlt\n%test\n%scalar\n%low\nnonzero\n%test\nscalar_valid\nu64\n%high\n57343\nle\n%test\n%scalar\n%high\nnonzero\n%test\ninvalid\nlabel\nscalar_valid\nu64\n%high\n1114111\nle\n%test\n%scalar\n%high\nzero\n%test\ninvalid\nstore64\n%state\n%value_at\n%scalar\nret\n%value_status\nlabel\npending_value\nret\n%pending\nlabel\ninvalid\nstore64\n%state\n%zero\n%zero\nret\n%failed\nend\nfunc\n__utf8_decode_terminal\n2\narg\n%state\n0\narg\n%terminal\n1\nu64\n%zero\n0\nu64\n%closed\n2\nu64\n%failed\n3\nne\n%test\n%terminal\n%closed\nnonzero\n%test\nfailure\nload64\n%remaining\n%state\n%zero\nnonzero\n%remaining\nfailure\nret\n%closed\nlabel\nfailure\nstore64\n%state\n%zero\n%zero\nret\n%failed\nend\nfunc\n__utf8_stream_recv\n2\narg\n%channel\n0\narg\n%state\n1\nu64\n%zero\n0\nu64\n%one\n1\nu64\n%scratch_at\n32\nadd\n%target\n%state\n%scratch_at\nlabel\nreceive\ncall\n%status\nchannel_recv\n2\n%channel\n%target\nzero\n%status\npending\nne\n%test\n%status\n%one\nnonzero\n%test\nterminal\nload8\n%byte\n%target\n%zero\ncall\n%status\n__utf8_decode_feed\n2\n%state\n%byte\nzero\n%status\nreceive\nret\n%status\nlabel\nterminal\ncall\n%status\n__utf8_decode_terminal\n2\n%state\n%status\nret\n%status\nlabel\npending\nret\n%zero\nend\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: utf8 lowering rejected token stream\n"

func next 3
arg %fd 0
arg %buffer 1
arg %capacity 2
u64 %zero 0
u64 %one 1
u64 %lf 10
u64 %length 0
label read
eq %test %length %capacity
nonzero %test full
add %seat %buffer %length
read %count %fd %seat %one
slt %test %count %zero
nonzero %test full
zero %count done
load8 %byte %seat %zero
eq %test %byte %lf
nonzero %test done
add %length %length %one
jump read
label done
ret %length
label full
ret %capacity
end

func same 4
arg %left 0
arg %llen 1
arg %right 2
arg %rlen 3
u64 %zero 0
u64 %one 1
ne %test %llen %rlen
nonzero %test no
u64 %index 0
label byte
eq %test %index %llen
nonzero %test yes
load8 %a %left %index
load8 %b %right %index
ne %test %a %b
nonzero %test no
add %index %index %one
jump byte
label yes
ret %one
label no
ret %zero
end

func put 2
arg %data 0
arg %length 1
u64 %fd 1
write %result %fd %data %length
ret %result
end

func emit 2
arg %data 0
arg %length 1
u64 %one 1
call %wrote put 2 %data %length
out newline
ret %one
end

func copy 3
arg %target 0
arg %source 1
arg %length 2
u64 %zero 0
u64 %one 1
u64 %max 63
le %test %length %max
zero %test bad
u64 %index 0
label byte
eq %test %index %length
nonzero %test done
load8 %value %source %index
store8 %target %index %value
add %index %index %one
jump byte
label done
ret %one
label bad
ret %zero
end

func nextcopy 4
arg %buffer 0
arg %capacity 1
arg %target 2
arg %target_capacity 3
u64 %zero 0
u64 %fd 0
call %length next 3 %fd %buffer %capacity
zero %length bad
le %test %target_capacity %length
nonzero %test bad
call %test copy 3 %target %buffer %length
zero %test bad
ret %length
label bad
ret %zero
end

func main 0
u64 %zero 0
u64 %one 1
u64 %capacity 4096
u64 %small 64
u64 %fd 0
u64 %used 0
alloc %buffer %capacity
alloc %status %small
alloc %channel %small
alloc %state %small
zero %buffer limited
zero %status limited
zero %channel limited
zero %state limited
label token
call %length next 3 %fd %buffer %capacity
zero %length finish
eq %test %length %capacity
nonzero %test invalid
data %word %wordlen marker
call %test same 4 %buffer %length %word %wordlen
nonzero %test lower
call %wrote emit 2 %buffer %length
jump token
label lower
call %alen nextcopy 4 %buffer %capacity %status %small
call %blen nextcopy 4 %buffer %capacity %channel %small
call %clen nextcopy 4 %buffer %capacity %state %small
zero %alen invalid
zero %blen invalid
zero %clen invalid
out callword
call %wrote emit 2 %status %alen
out functionword
out arity
call %wrote emit 2 %channel %blen
call %wrote emit 2 %state %clen
u64 %used 1
jump token
label finish
zero %used success
out helpers
label success
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end

