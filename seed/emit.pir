memory 32768
bytes top "memory M\nbytes B\nfunc F\n"
bytes body "arg A\nu64 U\ndata D\nfuncptr F\nadd B\nsub B\nmul B\neq P\nne P\nle P\nslt P\nload8 L\nload64 Q\nstore8 H\nstore64 V\nalloc C\nread I\nwrite I\ncall K\ninvoke Y\nlabel G\njump J\nzero Z\nnonzero Z\nout O\nerr O\nexit X\nret T\nend E\n"
bytes constsec ".section __TEXT,__const\n"
bytes memorya ".section __DATA,__data\n.p2align 3\n.globl _plang_memory_limit\n_plang_memory_limit:\n    .quad "
bytes memoryb "\n.section __DATA,__bss\n.p2align 4\n.globl _plang_arena\n_plang_arena:\n    .space "
bytes datahead ".p2align 0\nL_data_"
bytes datamid ":\n    .ascii "
bytes dataset "\n    .set L_size_"
bytes dataend ", . - L_data_"
bytes line "\n"
bytes texthead ".section __TEXT,__text,regular,pure_instructions\n.p2align 2\n.globl "
bytes mainname "_main"
bytes pirname "_pir_"
bytes prologue ":\n    stp x29, x30, [sp, #-16]!\n    mov x29, sp\n    sub sp, sp, #240\n"
bytes movz "    movz x9, #"
bytes arghead "    stur x"
bytes store "\n    stur x9, [x29, #-"
bytes store0 "    stur x0, [x29, #-"
bytes store11 "    stur x11, [x29, #-"
bytes close "]\n"
bytes load0 "    ldur x0, [x29, #-"
bytes load1 "    ldur x1, [x29, #-"
bytes load2 "    ldur x2, [x29, #-"
bytes load3 "    ldur x3, [x29, #-"
bytes load10 "    ldur x10, [x29, #-"
bytes load11 "    ldur x11, [x29, #-"
bytes alloc "    bl _plang_alloc\n    stur x0, [x29, #-"
bytes load9 "    ldur x9, [x29, #-"
bytes add11 "    add x11, x9, x10\n"
bytes sub11 "    sub x11, x9, x10\n"
bytes mul11 "    mul x11, x9, x10\n"
bytes cmp "    cmp x9, x10\n    cset x11, "
bytes eqcond "eq\n"
bytes necond "ne\n"
bytes lecond "ls\n"
bytes sltcond "lt\n"
bytes loadbyte "    add x11, x9, x10\n    ldrb w11, [x11]\n"
bytes loadword "    add x11, x9, x10\n    ldr x11, [x11]\n"
bytes storebyte "    add x9, x9, x10\n    strb w11, [x9]\n"
bytes storeword "    add x9, x9, x10\n    str x11, [x9]\n"
bytes dataa "    adrp x9, L_data_"
bytes datab "@PAGE\n    add x9, x9, L_data_"
bytes datac "@PAGEOFF\n    stur x9, [x29, #-"
bytes datad "]\n    mov x9, #L_size_"
bytes datae "\n    stur x9, [x29, #-"
bytes funca "    adrp x9, _pir_"
bytes funcb "@PAGE\n    add x9, x9, _pir_"
bytes funcc "@PAGEOFF\n    stur x9, [x29, #-"
bytes calla "    bl _pir_"
bytes blr "    blr x9\n"
bytes runtimea "    bl _plang_"
bytes readcall "    bl _plang_read\n"
bytes writecall "    bl _plang_write\n"
bytes labela "L_"
bytes labelb ":\n"
bytes jumpa "    b L_"
bytes cbza "]\n    cbz x9, L_"
bytes cbnza "]\n    cbnz x9, L_"
bytes outa "    adrp x0, L_data_"
bytes outb "@PAGE\n    add x0, x0, L_data_"
bytes outc "@PAGEOFF\n    mov x1, #L_size_"
bytes outd "\n    bl _plang_"
bytes exita "    movz x0, #"
bytes epilogue "    add sp, sp, #240\n    ldp x29, x30, [sp], #16\n    ret\n"
bytes comma ", [x29, #-"
bytes mainword "main"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: emitter rejected token stream\n"

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
u64 %result 1
ret %result
label no
ret %zero
end

func lookup 4
arg %token 0
arg %length 1
arg %table 2
arg %size 3
u64 %zero 0
u64 %one 1
u64 %space 32
u64 %lf 10
u64 %unknown 255
u64 %index 0
label record
le %test %size %index
nonzero %test missing
add %start %index %zero
label name
load8 %byte %table %index
eq %test %byte %space
nonzero %test code
add %index %index %one
jump name
label code
sub %width %index %start
add %name %table %start
call %test same 4 %token %length %name %width
add %index %index %one
load8 %code %table %index
nonzero %test found
label newline
load8 %byte %table %index
eq %test %byte %lf
nonzero %test advance
add %index %index %one
jump newline
label advance
add %index %index %one
jump record
label found
ret %code
label missing
ret %unknown
end

func put 2
arg %data 0
arg %length 1
u64 %fd 1
write %result %fd %data %length
ret %result
end

func reg 2
arg %token 0
arg %length 1
u64 %two 2
sub %length %length %two
add %token %token %two
call %result put 2 %token %length
ret %result
end


func main 0
u64 %zero 0
u64 %one 1
u64 %unknown 255
u64 %capacity 4096
u64 %fd 0
alloc %op %capacity
alloc %a %capacity
alloc %b %capacity
alloc %c %capacity
alloc %d %capacity
zero %op limited
zero %a limited
zero %b limited
zero %c limited
zero %d limited
data %table %tablesize top
data %piece %piecesize constsec
call %wrote put 2 %piece %piecesize
label top
data %table %tablesize top
call %length next 3 %fd %op %capacity
zero %length success
call %code lookup 4 %op %length %table %tablesize
eq %test %code %unknown
nonzero %test invalid
u64 %value 77
eq %test %code %value
nonzero %test memory
u64 %value 66
eq %test %code %value
nonzero %test bytes
u64 %value 70
eq %test %code %value
nonzero %test function
jump invalid
label memory
call %length next 3 %fd %a %capacity
zero %length invalid
data %piece %piecesize memorya
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %length
data %piece %piecesize memoryb
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %length
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
data %piece %piecesize constsec
call %wrote put 2 %piece %piecesize
jump top
label bytes
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
zero %alen invalid
zero %blen invalid
data %piece %piecesize datahead
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize datamid
call %wrote put 2 %piece %piecesize
call %wrote put 2 %b %blen
data %piece %piecesize dataset
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize dataend
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
jump top
label function
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
zero %alen invalid
zero %blen invalid
data %piece %piecesize texthead
call %wrote put 2 %piece %piecesize
data %piece %piecesize mainword
call %test same 4 %a %alen %piece %piecesize
nonzero %test function_main
data %piece %piecesize pirname
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
data %piece %piecesize pirname
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
jump function_tail
label function_main
data %piece %piecesize mainname
call %wrote put 2 %piece %piecesize
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
data %piece %piecesize mainname
call %wrote put 2 %piece %piecesize
label function_tail
data %piece %piecesize prologue
call %wrote put 2 %piece %piecesize
data %table %tablesize body
label body
data %table %tablesize body
call %length next 3 %fd %op %capacity
zero %length invalid
call %code lookup 4 %op %length %table %tablesize
eq %test %code %unknown
nonzero %test invalid
u64 %value 65
eq %test %code %value
nonzero %test arg
u64 %value 85
eq %test %code %value
nonzero %test u64
u64 %value 68
eq %test %code %value
nonzero %test data
u64 %value 70
eq %test %code %value
nonzero %test function_pointer
u64 %value 66
eq %test %code %value
nonzero %test binary
u64 %value 80
eq %test %code %value
nonzero %test compare
u64 %value 76
eq %test %code %value
nonzero %test load8
u64 %value 81
eq %test %code %value
nonzero %test load64
u64 %value 72
eq %test %code %value
nonzero %test store8
u64 %value 86
eq %test %code %value
nonzero %test store64
u64 %value 67
eq %test %code %value
nonzero %test allocation
u64 %value 73
eq %test %code %value
nonzero %test io
u64 %value 75
eq %test %code %value
nonzero %test call
u64 %value 89
eq %test %code %value
nonzero %test call
u64 %value 71
eq %test %code %value
nonzero %test label
u64 %value 74
eq %test %code %value
nonzero %test jump
u64 %value 90
eq %test %code %value
nonzero %test branch
u64 %value 79
eq %test %code %value
nonzero %test output
u64 %value 88
eq %test %code %value
nonzero %test exit
u64 %value 84
eq %test %code %value
nonzero %test return_op
u64 %value 69
eq %test %code %value
nonzero %test finish
jump invalid
label arg
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
data %piece %piecesize arghead
call %wrote put 2 %piece %piecesize
call %wrote put 2 %b %blen
data %piece %piecesize comma
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label u64
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
data %piece %piecesize movz
call %wrote put 2 %piece %piecesize
call %wrote put 2 %b %blen
data %piece %piecesize store
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label data
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
data %piece %piecesize dataa
call %wrote put 2 %piece %piecesize
call %wrote put 2 %c %length
data %piece %piecesize datab
call %wrote put 2 %piece %piecesize
call %wrote put 2 %c %length
data %piece %piecesize datac
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize datad
call %wrote put 2 %piece %piecesize
call %wrote put 2 %c %length
data %piece %piecesize datae
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label function_pointer
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
data %piece %piecesize funca
call %wrote put 2 %piece %piecesize
call %wrote put 2 %b %blen
data %piece %piecesize funcb
call %wrote put 2 %piece %piecesize
call %wrote put 2 %b %blen
data %piece %piecesize funcc
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label binary
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load10
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %c %length
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
load8 %byte %op %zero
u64 %char 97
eq %test %byte %char
nonzero %test binary_add
u64 %char 109
eq %test %byte %char
nonzero %test binary_mul
data %piece %piecesize sub11
jump binary_emit
label binary_add
data %piece %piecesize add11
jump binary_emit
label binary_mul
data %piece %piecesize mul11
label binary_emit
call %wrote put 2 %piece %piecesize
data %piece %piecesize store11
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label compare
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load10
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %c %length
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize cmp
call %wrote put 2 %piece %piecesize
load8 %byte %op %zero
u64 %char 101
eq %test %byte %char
nonzero %test compare_eq
u64 %char 110
eq %test %byte %char
nonzero %test compare_ne
u64 %char 108
eq %test %byte %char
nonzero %test compare_le
data %piece %piecesize sltcond
jump compare_emit
label compare_eq
data %piece %piecesize eqcond
jump compare_emit
label compare_ne
data %piece %piecesize necond
jump compare_emit
label compare_le
data %piece %piecesize lecond
label compare_emit
call %wrote put 2 %piece %piecesize
data %piece %piecesize store11
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label load8
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load10
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %c %length
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize loadbyte
call %wrote put 2 %piece %piecesize
data %piece %piecesize store11
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label store8
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load10
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load11
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %c %length
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize storebyte
call %wrote put 2 %piece %piecesize
jump body
label load64
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load10
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %c %length
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize loadword
call %wrote put 2 %piece %piecesize
data %piece %piecesize store11
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label store64
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load10
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load11
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %c %length
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize storeword
call %wrote put 2 %piece %piecesize
jump body
label allocation
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
data %piece %piecesize load0
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize alloc
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label io
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
call %code next 3 %fd %d %capacity
data %piece %piecesize load0
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load1
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %c %length
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize load2
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %d %code
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
load8 %byte %op %zero
u64 %char 114
eq %test %byte %char
nonzero %test io_read
data %piece %piecesize writecall
jump io_emit
label io_read
data %piece %piecesize readcall
label io_emit
call %wrote put 2 %piece %piecesize
data %piece %piecesize store0
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label call
load8 %byte %op %zero
u64 %char 105
eq %value %byte %char
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
call %length next 3 %fd %c %capacity
load8 %byte %c %zero
u64 %char 48
eq %test %byte %char
nonzero %test call_emit
call %code next 3 %fd %op %capacity
data %piece %piecesize load0
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %op %code
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
u64 %char 49
eq %test %byte %char
nonzero %test call_emit
call %code next 3 %fd %op %capacity
data %piece %piecesize load1
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %op %code
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
u64 %char 50
eq %test %byte %char
nonzero %test call_emit
call %code next 3 %fd %op %capacity
data %piece %piecesize load2
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %op %code
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
u64 %char 51
eq %test %byte %char
nonzero %test call_emit
call %code next 3 %fd %op %capacity
data %piece %piecesize load3
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %op %code
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
u64 %char 52
ne %test %byte %char
nonzero %test invalid
label call_emit
nonzero %value invoke_emit
data %piece %piecesize calla
call %wrote put 2 %piece %piecesize
call %wrote put 2 %b %blen
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
jump call_store
label invoke_emit
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %b %blen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize blr
call %wrote put 2 %piece %piecesize
label call_store
data %piece %piecesize store0
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
jump body
label branch
call %alen next 3 %fd %a %capacity
call %blen next 3 %fd %b %capacity
data %piece %piecesize load9
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
load8 %byte %op %zero
u64 %char 122
eq %test %byte %char
nonzero %test branch_zero
data %piece %piecesize cbnza
jump branch_emit
label branch_zero
data %piece %piecesize cbza
label branch_emit
call %wrote put 2 %piece %piecesize
call %wrote put 2 %b %blen
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
jump body
label output
call %alen next 3 %fd %a %capacity
data %piece %piecesize outa
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize outb
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize outc
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize outd
call %wrote put 2 %piece %piecesize
call %wrote put 2 %op %length
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
jump body
label label
call %alen next 3 %fd %a %capacity
data %piece %piecesize labela
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize labelb
call %wrote put 2 %piece %piecesize
jump body
label jump
call %alen next 3 %fd %a %capacity
data %piece %piecesize jumpa
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
jump body
label exit
call %alen next 3 %fd %a %capacity
data %piece %piecesize exita
call %wrote put 2 %piece %piecesize
call %wrote put 2 %a %alen
data %piece %piecesize line
call %wrote put 2 %piece %piecesize
data %piece %piecesize epilogue
call %wrote put 2 %piece %piecesize
jump body
label return_op
call %alen next 3 %fd %a %capacity
data %piece %piecesize load0
call %wrote put 2 %piece %piecesize
call %wrote reg 2 %a %alen
data %piece %piecesize close
call %wrote put 2 %piece %piecesize
data %piece %piecesize epilogue
call %wrote put 2 %piece %piecesize
jump body
label finish
jump top
label success
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
