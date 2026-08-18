memory 16777216
bytes top "memory M\nbytes B\nfunc F\n"
bytes body "arg A\nu64 U\ndata D\nadd B\nsub B\neq P\nne P\nle P\nslt P\nload8 L\nalloc C\nread I\nwrite I\ncall K\nlabel G\njump J\nzero Z\nnonzero Z\nout O\nerr O\nexit X\nret T\nend E\n"
bytes constsec ".section __TEXT,__const\n"
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
bytes alloc "    bl _plang_alloc\n    stur x0, [x29, #-"
bytes load9 "    ldur x9, [x29, #-"
bytes add11 "    add x11, x9, x10\n"
bytes sub11 "    sub x11, x9, x10\n"
bytes cmp "    cmp x9, x10\n    cset x11, "
bytes eqcond "eq\n"
bytes necond "ne\n"
bytes lecond "ls\n"
bytes sltcond "lt\n"
bytes loadbyte "    add x11, x9, x10\n    ldrb w11, [x11]\n"
bytes dataa "    adrp x9, L_data_"
bytes datab "@PAGE\n    add x9, x9, L_data_"
bytes datac "@PAGEOFF\n    stur x9, [x29, #-"
bytes datad "]\n    mov x9, #L_size_"
bytes datae "\n    stur x9, [x29, #-"
bytes calla "    bl _pir_"
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
arg %r8 0
arg %r16 1
arg %r24 2
u64 %r32 0
u64 %r40 1
u64 %r48 10
u64 %r56 0
label next_read
eq %r64 %r56 %r24
nonzero %r64 next_full
add %r72 %r16 %r56
read %r80 %r8 %r72 %r40
slt %r64 %r80 %r32
nonzero %r64 next_full
zero %r80 next_done
load8 %r88 %r72 %r32
eq %r64 %r88 %r48
nonzero %r64 next_done
add %r56 %r56 %r40
jump next_read
label next_done
ret %r56
label next_full
ret %r24
end

func same 4
arg %r8 0
arg %r16 1
arg %r24 2
arg %r32 3
u64 %r40 0
u64 %r48 1
ne %r56 %r16 %r32
nonzero %r56 same_no
u64 %r64 0
label same_byte
eq %r56 %r64 %r16
nonzero %r56 same_yes
load8 %r72 %r8 %r64
load8 %r80 %r24 %r64
ne %r56 %r72 %r80
nonzero %r56 same_no
add %r64 %r64 %r48
jump same_byte
label same_yes
u64 %r88 1
ret %r88
label same_no
ret %r40
end

func lookup 4
arg %r8 0
arg %r16 1
arg %r24 2
arg %r32 3
u64 %r40 0
u64 %r48 1
u64 %r56 32
u64 %r64 10
  u64 %r80 255
u64 %r88 0
label lookup_record
le %r96 %r32 %r88
nonzero %r96 lookup_missing
add %r104 %r88 %r40
label lookup_name
load8 %r112 %r24 %r88
eq %r96 %r112 %r56
nonzero %r96 lookup_code
add %r88 %r88 %r48
jump lookup_name
label lookup_code
sub %r120 %r88 %r104
add %r128 %r24 %r104
call %r96 same 4 %r8 %r16 %r128 %r120
add %r88 %r88 %r48
load8 %r136 %r24 %r88
  nonzero %r96 lookup_found
label lookup_newline
load8 %r112 %r24 %r88
eq %r96 %r112 %r64
nonzero %r96 lookup_advance
add %r88 %r88 %r48
jump lookup_newline
label lookup_advance
add %r88 %r88 %r48
jump lookup_record
label lookup_found
ret %r136
label lookup_missing
ret %r80
end

func put 2
arg %r8 0
arg %r16 1
u64 %r24 1
write %r32 %r24 %r8 %r16
ret %r32
end

func reg 2
arg %r8 0
arg %r16 1
u64 %r24 2
sub %r16 %r16 %r24
add %r8 %r8 %r24
call %r32 put 2 %r8 %r16
ret %r32
end


func main 0
u64 %r8 0
u64 %r16 1
u64 %r24 255
u64 %r32 4096
u64 %r40 0
alloc %r48 %r32
alloc %r56 %r32
alloc %r64 %r32
alloc %r72 %r32
alloc %r192 %r32
zero %r48 self_limited
zero %r56 self_limited
zero %r64 self_limited
zero %r72 self_limited
zero %r192 self_limited
data %r80 %r88 top
data %r96 %r104 constsec
call %r112 put 2 %r96 %r104
label self_top
data %r80 %r88 top
call %r120 next 3 %r40 %r48 %r32
zero %r120 self_success
call %r128 lookup 4 %r48 %r120 %r80 %r88
eq %r136 %r128 %r24
nonzero %r136 self_invalid
u64 %r168 77
eq %r136 %r128 %r168
nonzero %r136 self_memory
u64 %r168 66
eq %r136 %r128 %r168
nonzero %r136 self_bytes
u64 %r168 70
eq %r136 %r128 %r168
nonzero %r136 self_function
jump self_invalid
label self_memory
call %r120 next 3 %r40 %r56 %r32
zero %r120 self_invalid
jump self_top
label self_bytes
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
zero %r152 self_invalid
zero %r160 self_invalid
data %r96 %r104 datahead
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 datamid
call %r112 put 2 %r96 %r104
call %r112 put 2 %r64 %r160
data %r96 %r104 dataset
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 dataend
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 line
call %r112 put 2 %r96 %r104
jump self_top
label self_function
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
zero %r152 self_invalid
zero %r160 self_invalid
data %r96 %r104 texthead
call %r112 put 2 %r96 %r104
data %r96 %r104 mainword
call %r136 same 4 %r56 %r152 %r96 %r104
nonzero %r136 self_function_main
data %r96 %r104 pirname
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 line
call %r112 put 2 %r96 %r104
data %r96 %r104 pirname
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
jump self_function_tail
label self_function_main
data %r96 %r104 mainname
call %r112 put 2 %r96 %r104
data %r96 %r104 line
call %r112 put 2 %r96 %r104
data %r96 %r104 mainname
call %r112 put 2 %r96 %r104
label self_function_tail
data %r96 %r104 prologue
call %r112 put 2 %r96 %r104
data %r80 %r88 body
label self_body
data %r80 %r88 body
call %r120 next 3 %r40 %r48 %r32
zero %r120 self_invalid
call %r128 lookup 4 %r48 %r120 %r80 %r88
eq %r136 %r128 %r24
nonzero %r136 self_invalid
u64 %r168 65
eq %r136 %r128 %r168
nonzero %r136 self_arg
u64 %r168 85
eq %r136 %r128 %r168
nonzero %r136 self_u64
u64 %r168 68
eq %r136 %r128 %r168
nonzero %r136 self_data
u64 %r168 66
eq %r136 %r128 %r168
nonzero %r136 self_binary
u64 %r168 80
eq %r136 %r128 %r168
nonzero %r136 self_compare
u64 %r168 76
eq %r136 %r128 %r168
nonzero %r136 self_load8
u64 %r168 67
eq %r136 %r128 %r168
nonzero %r136 self_allocation
u64 %r168 73
eq %r136 %r128 %r168
nonzero %r136 self_io
u64 %r168 75
eq %r136 %r128 %r168
nonzero %r136 self_call
u64 %r168 71
eq %r136 %r128 %r168
nonzero %r136 self_label
u64 %r168 74
eq %r136 %r128 %r168
nonzero %r136 self_jump
u64 %r168 90
eq %r136 %r128 %r168
nonzero %r136 self_branch
u64 %r168 79
eq %r136 %r128 %r168
nonzero %r136 self_output
u64 %r168 88
eq %r136 %r128 %r168
nonzero %r136 self_exit
u64 %r168 84
eq %r136 %r128 %r168
nonzero %r136 self_return
u64 %r168 69
eq %r136 %r128 %r168
nonzero %r136 self_finish
jump self_invalid
label self_arg
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
data %r96 %r104 arghead
call %r112 put 2 %r96 %r104
call %r112 put 2 %r64 %r160
data %r96 %r104 comma
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_u64
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
data %r96 %r104 movz
call %r112 put 2 %r96 %r104
call %r112 put 2 %r64 %r160
data %r96 %r104 store
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_data
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
call %r120 next 3 %r40 %r72 %r32
data %r96 %r104 dataa
call %r112 put 2 %r96 %r104
call %r112 put 2 %r72 %r120
data %r96 %r104 datab
call %r112 put 2 %r96 %r104
call %r112 put 2 %r72 %r120
data %r96 %r104 datac
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 datad
call %r112 put 2 %r96 %r104
call %r112 put 2 %r72 %r120
data %r96 %r104 datae
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r64 %r160
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_binary
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
call %r120 next 3 %r40 %r72 %r32
data %r96 %r104 load9
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r64 %r160
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 load10
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r72 %r120
data %r96 %r104 close
call %r112 put 2 %r96 %r104
load8 %r176 %r48 %r8
u64 %r184 97
eq %r136 %r176 %r184
nonzero %r136 self_binary_add
data %r96 %r104 sub11
jump self_binary_emit
label self_binary_add
data %r96 %r104 add11
label self_binary_emit
call %r112 put 2 %r96 %r104
data %r96 %r104 store11
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_compare
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
call %r120 next 3 %r40 %r72 %r32
data %r96 %r104 load9
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r64 %r160
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 load10
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r72 %r120
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 cmp
call %r112 put 2 %r96 %r104
load8 %r176 %r48 %r8
u64 %r184 101
eq %r136 %r176 %r184
nonzero %r136 self_compare_eq
u64 %r184 110
eq %r136 %r176 %r184
nonzero %r136 self_compare_ne
u64 %r184 108
eq %r136 %r176 %r184
nonzero %r136 self_compare_le
data %r96 %r104 sltcond
jump self_compare_emit
label self_compare_eq
data %r96 %r104 eqcond
jump self_compare_emit
label self_compare_ne
data %r96 %r104 necond
jump self_compare_emit
label self_compare_le
data %r96 %r104 lecond
label self_compare_emit
call %r112 put 2 %r96 %r104
data %r96 %r104 store11
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_load8
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
call %r120 next 3 %r40 %r72 %r32
data %r96 %r104 load9
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r64 %r160
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 load10
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r72 %r120
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 loadbyte
call %r112 put 2 %r96 %r104
data %r96 %r104 store11
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_allocation
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
data %r96 %r104 load0
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r64 %r160
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 alloc
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_io
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
call %r120 next 3 %r40 %r72 %r32
call %r128 next 3 %r40 %r192 %r32
data %r96 %r104 load0
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r64 %r160
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 load1
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r72 %r120
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 load2
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r192 %r128
data %r96 %r104 close
call %r112 put 2 %r96 %r104
load8 %r176 %r48 %r8
u64 %r184 114
eq %r136 %r176 %r184
nonzero %r136 self_io_read
data %r96 %r104 writecall
jump self_io_emit
label self_io_read
data %r96 %r104 readcall
label self_io_emit
call %r112 put 2 %r96 %r104
data %r96 %r104 store0
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_call
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
call %r120 next 3 %r40 %r72 %r32
load8 %r176 %r72 %r8
u64 %r184 48
eq %r136 %r176 %r184
nonzero %r136 self_call_emit
call %r128 next 3 %r40 %r48 %r32
data %r96 %r104 load0
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r48 %r128
data %r96 %r104 close
call %r112 put 2 %r96 %r104
u64 %r184 49
eq %r136 %r176 %r184
nonzero %r136 self_call_emit
call %r128 next 3 %r40 %r48 %r32
data %r96 %r104 load1
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r48 %r128
data %r96 %r104 close
call %r112 put 2 %r96 %r104
u64 %r184 50
eq %r136 %r176 %r184
nonzero %r136 self_call_emit
call %r128 next 3 %r40 %r48 %r32
data %r96 %r104 load2
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r48 %r128
data %r96 %r104 close
call %r112 put 2 %r96 %r104
u64 %r184 51
eq %r136 %r176 %r184
nonzero %r136 self_call_emit
call %r128 next 3 %r40 %r48 %r32
data %r96 %r104 load3
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r48 %r128
data %r96 %r104 close
call %r112 put 2 %r96 %r104
u64 %r184 52
ne %r136 %r176 %r184
nonzero %r136 self_invalid
label self_call_emit
data %r96 %r104 calla
call %r112 put 2 %r96 %r104
call %r112 put 2 %r64 %r160
data %r96 %r104 line
call %r112 put 2 %r96 %r104
data %r96 %r104 store0
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
jump self_body
label self_branch
call %r152 next 3 %r40 %r56 %r32
call %r160 next 3 %r40 %r64 %r32
data %r96 %r104 load9
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
load8 %r176 %r48 %r8
u64 %r184 122
eq %r136 %r176 %r184
nonzero %r136 self_branch_zero
data %r96 %r104 cbnza
jump self_branch_emit
label self_branch_zero
data %r96 %r104 cbza
label self_branch_emit
call %r112 put 2 %r96 %r104
call %r112 put 2 %r64 %r160
data %r96 %r104 line
call %r112 put 2 %r96 %r104
jump self_body
label self_output
call %r152 next 3 %r40 %r56 %r32
data %r96 %r104 outa
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 outb
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 outc
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 outd
call %r112 put 2 %r96 %r104
call %r112 put 2 %r48 %r120
data %r96 %r104 line
call %r112 put 2 %r96 %r104
jump self_body
label self_label
call %r152 next 3 %r40 %r56 %r32
data %r96 %r104 labela
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 labelb
call %r112 put 2 %r96 %r104
jump self_body
label self_jump
call %r152 next 3 %r40 %r56 %r32
data %r96 %r104 jumpa
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 line
call %r112 put 2 %r96 %r104
jump self_body
label self_exit
call %r152 next 3 %r40 %r56 %r32
data %r96 %r104 exita
call %r112 put 2 %r96 %r104
call %r112 put 2 %r56 %r152
data %r96 %r104 line
call %r112 put 2 %r96 %r104
data %r96 %r104 epilogue
call %r112 put 2 %r96 %r104
jump self_body
label self_return
call %r152 next 3 %r40 %r56 %r32
data %r96 %r104 load0
call %r112 put 2 %r96 %r104
call %r112 reg 2 %r56 %r152
data %r96 %r104 close
call %r112 put 2 %r96 %r104
data %r96 %r104 epilogue
call %r112 put 2 %r96 %r104
jump self_body
label self_finish
jump self_top
label self_success
exit 0
label self_limited
err limited
exit 1
label self_invalid
err invalid
exit 1
end
