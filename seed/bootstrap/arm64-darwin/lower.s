.section __TEXT,__const
.set M,8192
.if (M&(M-1))||(M<4096)||(M>>25)
.error "plang0: memory"
.endif
.section __DATA,__data
.p2align 3
.globl _plang_memory_limit
_plang_memory_limit:
    .quad M
.section __DATA,__bss
.p2align 4
.globl _plang_arena
_plang_arena:
    .space 8192
.section __TEXT,__const
.p2align 0
L_data_top:
    .ascii "memory 1\nbytes 2\nfunc F\n"
    .set L_size_top, . - L_data_top
.p2align 0
L_data_body:
    .ascii "arg 2\nu64 2\ndata 3\nfuncptr 2\nadd 3\nsub 3\nmul 3\nand 3\nor 3\nxor 3\nshl 3\nshr 3\neq 3\nne 3\nlt 3\nle 3\nslt 3\nload8 3\nload64 3\nstore8 3\nstore64 3\nalloc 2\nargv 3\nread 4\nwrite 4\nopen 2\nclose 2\ncall C\ninvoke I\nlabel L\njump L\nzero Z\nnonzero Z\nout 1\nerr 1\nexit 1\nret 1\nend E\n"
    .set L_size_body, . - L_data_body
.p2align 0
L_data_slots:
    .ascii "8\n16\n24\n32\n40\n48\n56\n64\n72\n80\n88\n96\n104\n112\n120\n128\n136\n144\n152\n160\n168\n176\n184\n192\n200\n208\n216\n224\n232\n240\n"
    .set L_size_slots, . - L_data_slots
.p2align 0
L_data_prefix:
    .ascii "%r"
    .set L_size_prefix, . - L_data_prefix
.p2align 0
L_data_join:
    .ascii "_"
    .set L_size_join, . - L_data_join
.p2align 0
L_data_newline:
    .ascii "\n"
    .set L_size_newline, . - L_data_newline
.p2align 0
L_data_limited:
    .ascii "plang0: memory limit\n"
    .set L_size_limited, . - L_data_limited
.p2align 0
L_data_invalid:
    .ascii "plang0: lowering rejected token stream\n"
    .set L_size_invalid, . - L_data_invalid
.set L_a,3
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_next
_pir_next__arity_3:
_pir_next:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-32]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,10
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
L_next_read:
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-64]
    ldur x9, [x29, #-64]
    cbnz x9, L_next_full
    ldur x9, [x29, #-16]
    ldur x10, [x29, #-56]
    add x11, x9, x10
    stur x11, [x29, #-72]
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-40]
    bl _plang_read
    stur x0, [x29, #-80]
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, lt
    stur x11, [x29, #-64]
    ldur x9, [x29, #-64]
    cbnz x9, L_next_full
    ldur x9, [x29, #-80]
    cbz x9, L_next_done
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-32]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-48]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-64]
    ldur x9, [x29, #-64]
    cbnz x9, L_next_done
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-56]
    b L_next_read
L_next_done:
    ldur x0, [x29, #-56]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_next_full:
    ldur x0, [x29, #-24]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,4
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_same
_pir_same__arity_4:
_pir_same:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
    .if 3>=L_a
    .error "plang0: arg index"
    .endif
    stur x3, [x29, #-32]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
    ldur x9, [x29, #-16]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, ne
    stur x11, [x29, #-56]
    ldur x9, [x29, #-56]
    cbnz x9, L_same_no
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
L_same_byte:
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-16]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-56]
    ldur x9, [x29, #-56]
    cbnz x9, L_same_yes
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-64]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-72]
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-64]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-80]
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-80]
    cmp x9, x10
    cset x11, ne
    stur x11, [x29, #-56]
    ldur x9, [x29, #-56]
    cbnz x9, L_same_no
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-64]
    b L_same_byte
L_same_yes:
    ldur x0, [x29, #-48]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_same_no:
    ldur x0, [x29, #-40]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,4
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_lookup
_pir_lookup__arity_4:
_pir_lookup:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
    .if 3>=L_a
    .error "plang0: arg index"
    .endif
    stur x3, [x29, #-32]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,32
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,10
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
.set U,255
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-72]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-80]
L_lookup_record:
    ldur x9, [x29, #-32]
    ldur x10, [x29, #-80]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_lookup_missing
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-96]
L_lookup_name:
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-80]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-104]
    ldur x9, [x29, #-104]
    ldur x10, [x29, #-56]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_lookup_code
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-80]
    ldur x9, [x29, #-32]
    ldur x10, [x29, #-80]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_lookup_missing
    b L_lookup_name
L_lookup_code:
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-96]
    sub x11, x9, x10
    stur x11, [x29, #-112]
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-96]
    add x11, x9, x10
    stur x11, [x29, #-120]
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-16]
    ldur x2, [x29, #-120]
    ldur x3, [x29, #-112]
    bl _pir_same__arity_4
    stur x0, [x29, #-88]
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-80]
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-80]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-128]
    ldur x9, [x29, #-88]
    cbnz x9, L_lookup_found
L_lookup_newline:
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-80]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-104]
    ldur x9, [x29, #-104]
    ldur x10, [x29, #-64]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_lookup_advance
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-80]
    ldur x9, [x29, #-32]
    ldur x10, [x29, #-80]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_lookup_missing
    b L_lookup_newline
L_lookup_advance:
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-80]
    b L_lookup_record
L_lookup_found:
    ldur x0, [x29, #-128]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_lookup_missing:
    ldur x0, [x29, #-72]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,2
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_decimal
_pir_decimal__arity_2:
_pir_decimal:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-24]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-32]
.set U,10
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,48
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,57
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,255
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-72]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-80]
    ldur x9, [x29, #-16]
    cbz x9, L_decimal_bad
L_decimal_digit:
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-16]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_decimal_done
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-72]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-96]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-96]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbz x9, L_decimal_bad
    ldur x9, [x29, #-96]
    ldur x10, [x29, #-56]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbz x9, L_decimal_bad
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-40]
    mul x11, x9, x10
    stur x11, [x29, #-80]
    ldur x9, [x29, #-96]
    ldur x10, [x29, #-48]
    sub x11, x9, x10
    stur x11, [x29, #-96]
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-96]
    add x11, x9, x10
    stur x11, [x29, #-80]
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-32]
    add x11, x9, x10
    stur x11, [x29, #-72]
    b L_decimal_digit
L_decimal_done:
    ldur x0, [x29, #-80]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_decimal_bad:
    ldur x0, [x29, #-64]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,2
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_put
_pir_put__arity_2:
_pir_put:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-24]
    ldur x0, [x29, #-24]
    ldur x1, [x29, #-8]
    ldur x2, [x29, #-16]
    bl _plang_write
    stur x0, [x29, #-32]
    ldur x0, [x29, #-32]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,2
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_emit
_pir_emit__arity_2:
_pir_emit:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-24]
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-16]
    bl _pir_put__arity_2
    stur x0, [x29, #-32]
    adrp x0, L_data_newline@PAGE
    add x0, x0, L_data_newline@PAGEOFF
    mov x1, #L_size_newline
    bl _plang_out
    ldur x0, [x29, #-24]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,3
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_copy
_pir_copy__arity_3:
_pir_copy:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-32]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,63
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-48]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-56]
    ldur x9, [x29, #-56]
    cbz x9, L_copy_bad
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
L_copy_byte:
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-56]
    ldur x9, [x29, #-56]
    cbnz x9, L_copy_done
    ldur x9, [x29, #-16]
    ldur x10, [x29, #-64]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-72]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-64]
    ldur x11, [x29, #-72]
    add x9, x9, x10
    strb w11, [x9]
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-64]
    b L_copy_byte
L_copy_done:
    ldur x0, [x29, #-40]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_copy_bad:
    ldur x0, [x29, #-32]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,4
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_find
_pir_find__arity_4:
_pir_find:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
    .if 3>=L_a
    .error "plang0: arg index"
    .endif
    stur x3, [x29, #-32]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,64
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,255
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-72]
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-80]
L_find_record:
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_find_missing
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-96]
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-104]
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-16]
    ldur x2, [x29, #-104]
    ldur x3, [x29, #-96]
    bl _pir_same__arity_4
    stur x0, [x29, #-88]
    ldur x9, [x29, #-88]
    cbnz x9, L_find_found
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-56]
    add x11, x9, x10
    stur x11, [x29, #-80]
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-72]
    b L_find_record
L_find_found:
    ldur x0, [x29, #-72]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_find_missing:
    ldur x0, [x29, #-64]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,4
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_save
_pir_save__arity_4:
_pir_save:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
    .if 3>=L_a
    .error "plang0: arg index"
    .endif
    stur x3, [x29, #-32]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,64
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,63
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
    ldur x9, [x29, #-32]
    ldur x10, [x29, #-64]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-72]
    ldur x9, [x29, #-72]
    cbz x9, L_save_bad
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-80]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-88]
L_save_seek:
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-16]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-72]
    ldur x9, [x29, #-72]
    cbnz x9, L_save_copy
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-56]
    add x11, x9, x10
    stur x11, [x29, #-88]
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-80]
    b L_save_seek
L_save_copy:
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-40]
    ldur x11, [x29, #-32]
    add x9, x9, x10
    strb w11, [x9]
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-96]
    ldur x0, [x29, #-96]
    ldur x1, [x29, #-24]
    ldur x2, [x29, #-32]
    bl _pir_copy__arity_3
    stur x0, [x29, #-72]
    ldur x0, [x29, #-72]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_save_bad:
    ldur x0, [x29, #-40]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,1
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_slot
_pir_slot__arity_1:
_pir_slot:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-16]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-24]
.set U,10
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-32]
    adrp x9, L_data_slots@PAGE
    add x9, x9, L_data_slots@PAGEOFF
    stur x9, [x29, #-40]
    mov x9, #L_size_slots
    stur x9, [x29, #-48]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-72]
L_slot_seek:
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-56]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbnz x9, L_slot_bad
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-8]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbnz x9, L_slot_width
    ldur x9, [x29, #-40]
    ldur x10, [x29, #-56]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbz x9, L_slot_next
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-24]
    add x11, x9, x10
    stur x11, [x29, #-64]
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-24]
    add x11, x9, x10
    stur x11, [x29, #-72]
L_slot_next:
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-24]
    add x11, x9, x10
    stur x11, [x29, #-56]
    b L_slot_seek
L_slot_width:
    ldur x9, [x29, #-40]
    ldur x10, [x29, #-56]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-88]
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbnz x9, L_slot_done
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-24]
    add x11, x9, x10
    stur x11, [x29, #-56]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-56]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbnz x9, L_slot_bad
    b L_slot_width
L_slot_done:
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-72]
    sub x11, x9, x10
    stur x11, [x29, #-96]
    ldur x9, [x29, #-40]
    ldur x10, [x29, #-72]
    add x11, x9, x10
    stur x11, [x29, #-104]
    adrp x0, L_data_prefix@PAGE
    add x0, x0, L_data_prefix@PAGEOFF
    mov x1, #L_size_prefix
    bl _plang_out
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-96]
    bl _pir_emit__arity_2
    stur x0, [x29, #-112]
    ldur x0, [x29, #-24]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_slot_bad:
    ldur x0, [x29, #-16]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,3
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_map
_pir_map__arity_3:
_pir_map:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-32]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,37
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,30
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,255
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
    ldur x9, [x29, #-16]
    cbz x9, L_map_bad
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-32]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-72]
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-48]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbz x9, L_map_raw
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-32]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-88]
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-96]
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-16]
    ldur x2, [x29, #-96]
    ldur x3, [x29, #-88]
    bl _pir_find__arity_4
    stur x0, [x29, #-104]
    ldur x9, [x29, #-104]
    ldur x10, [x29, #-64]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbz x9, L_map_found
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-88]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-80]
    ldur x9, [x29, #-80]
    cbnz x9, L_map_bad
    ldur x0, [x29, #-96]
    ldur x1, [x29, #-88]
    ldur x2, [x29, #-8]
    ldur x3, [x29, #-16]
    bl _pir_save__arity_4
    stur x0, [x29, #-80]
    ldur x9, [x29, #-80]
    cbz x9, L_map_bad
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-32]
    add x11, x9, x10
    stur x11, [x29, #-104]
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-88]
    ldur x9, [x29, #-24]
    ldur x10, [x29, #-32]
    ldur x11, [x29, #-88]
    add x9, x9, x10
    strb w11, [x9]
L_map_found:
    ldur x0, [x29, #-104]
    bl _pir_slot__arity_1
    stur x0, [x29, #-80]
    ldur x0, [x29, #-80]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_map_raw:
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-16]
    bl _pir_emit__arity_2
    stur x0, [x29, #-80]
    ldur x0, [x29, #-80]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_map_bad:
    ldur x0, [x29, #-32]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,4
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_qualify
_pir_qualify__arity_4:
_pir_qualify:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
    .if 3>=L_a
    .error "plang0: arg index"
    .endif
    stur x3, [x29, #-32]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-16]
    bl _pir_put__arity_2
    stur x0, [x29, #-48]
    adrp x0, L_data_join@PAGE
    add x0, x0, L_data_join@PAGEOFF
    mov x1, #L_size_join
    bl _plang_out
    ldur x0, [x29, #-24]
    ldur x1, [x29, #-32]
    bl _pir_emit__arity_2
    stur x0, [x29, #-48]
    ldur x0, [x29, #-40]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,4
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_fixed
_pir_fixed__arity_4:
_pir_fixed:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
    .if 3>=L_a
    .error "plang0: arg index"
    .endif
    stur x3, [x29, #-32]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
L_fixed_token:
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-72]
    ldur x9, [x29, #-72]
    cbnz x9, L_fixed_done
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-8]
    ldur x2, [x29, #-16]
    bl _pir_next__arity_3
    stur x0, [x29, #-80]
    ldur x9, [x29, #-80]
    cbz x9, L_fixed_bad
    ldur x9, [x29, #-80]
    ldur x10, [x29, #-16]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-72]
    ldur x9, [x29, #-72]
    cbnz x9, L_fixed_bad
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-32]
    bl _pir_map__arity_3
    stur x0, [x29, #-72]
    ldur x9, [x29, #-72]
    cbz x9, L_fixed_bad
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-48]
    add x11, x9, x10
    stur x11, [x29, #-64]
    b L_fixed_token
L_fixed_done:
    ldur x0, [x29, #-48]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_fixed_bad:
    ldur x0, [x29, #-40]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,3
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_raw
_pir_raw__arity_3:
_pir_raw:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
    .if 1>=L_a
    .error "plang0: arg index"
    .endif
    stur x1, [x29, #-16]
    .if 2>=L_a
    .error "plang0: arg index"
    .endif
    stur x2, [x29, #-24]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-32]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
L_raw_token:
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-64]
    ldur x9, [x29, #-64]
    cbnz x9, L_raw_done
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-8]
    ldur x2, [x29, #-16]
    bl _pir_next__arity_3
    stur x0, [x29, #-72]
    ldur x9, [x29, #-72]
    cbz x9, L_raw_bad
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-16]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-64]
    ldur x9, [x29, #-64]
    cbnz x9, L_raw_bad
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-72]
    bl _pir_emit__arity_2
    stur x0, [x29, #-80]
    ldur x9, [x29, #-56]
    ldur x10, [x29, #-40]
    add x11, x9, x10
    stur x11, [x29, #-56]
    b L_raw_token
L_raw_done:
    ldur x0, [x29, #-40]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_raw_bad:
    ldur x0, [x29, #-32]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,0
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _main
_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-8]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-16]
.set U,48
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-24]
.set U,255
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-32]
.set U,4096
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-40]
.set U,2048
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-48]
.set U,64
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-56]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-64]
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-72]
    ldur x0, [x29, #-40]
    bl _plang_alloc
    stur x0, [x29, #-80]
    ldur x0, [x29, #-48]
    bl _plang_alloc
    stur x0, [x29, #-88]
    ldur x0, [x29, #-56]
    bl _plang_alloc
    stur x0, [x29, #-96]
    ldur x9, [x29, #-80]
    cbz x9, L_main_limited
    ldur x9, [x29, #-88]
    cbz x9, L_main_limited
    ldur x9, [x29, #-96]
    cbz x9, L_main_limited
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-8]
    ldur x11, [x29, #-8]
    add x9, x9, x10
    strb w11, [x9]
    adrp x9, L_data_top@PAGE
    add x9, x9, L_data_top@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_top
    stur x9, [x29, #-112]
    adrp x9, L_data_body@PAGE
    add x9, x9, L_data_body@PAGEOFF
    stur x9, [x29, #-120]
    mov x9, #L_size_body
    stur x9, [x29, #-128]
L_main_token:
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-40]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    cbz x9, L_main_finish
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-40]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_emit__arity_2
    stur x0, [x29, #-152]
    ldur x9, [x29, #-72]
    cbz x9, L_main_outside
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    ldur x2, [x29, #-120]
    ldur x3, [x29, #-128]
    bl _pir_lookup__arity_4
    stur x0, [x29, #-160]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
.set U,69
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-168]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-168]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_end
.set U,67
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-168]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-168]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call
.set U,73
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-168]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-168]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invoke
.set U,76
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-168]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-168]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_label
.set U,90
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-168]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-168]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_branch
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-24]
    sub x11, x9, x10
    stur x11, [x29, #-176]
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-176]
    ldur x3, [x29, #-88]
    bl _pir_fixed__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    b L_main_token
L_main_end:
.set U,0
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-72]
    b L_main_token
L_main_call:
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-16]
    ldur x3, [x29, #-88]
    bl _pir_fixed__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-16]
    bl _pir_raw__arity_3
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-40]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_emit__arity_2
    stur x0, [x29, #-152]
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_decimal__arity_2
    stur x0, [x29, #-176]
    ldur x9, [x29, #-176]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-176]
    ldur x3, [x29, #-88]
    bl _pir_fixed__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    b L_main_token
L_main_invoke:
.set U,2
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-184]
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-184]
    ldur x3, [x29, #-88]
    bl _pir_fixed__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-40]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_emit__arity_2
    stur x0, [x29, #-152]
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_decimal__arity_2
    stur x0, [x29, #-176]
    ldur x9, [x29, #-176]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-176]
    ldur x3, [x29, #-88]
    bl _pir_fixed__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    b L_main_token
L_main_label:
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-40]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-96]
    ldur x1, [x29, #-192]
    ldur x2, [x29, #-80]
    ldur x3, [x29, #-136]
    bl _pir_qualify__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    b L_main_token
L_main_branch:
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-16]
    ldur x3, [x29, #-88]
    bl _pir_fixed__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-40]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-96]
    ldur x1, [x29, #-192]
    ldur x2, [x29, #-80]
    ldur x3, [x29, #-136]
    bl _pir_qualify__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    b L_main_token
L_main_outside:
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    ldur x2, [x29, #-104]
    ldur x3, [x29, #-112]
    bl _pir_lookup__arity_4
    stur x0, [x29, #-160]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
.set U,70
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-168]
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-168]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_function
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-24]
    sub x11, x9, x10
    stur x11, [x29, #-176]
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-40]
    ldur x2, [x29, #-176]
    bl _pir_raw__arity_3
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    b L_main_token
L_main_function:
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-40]
    bl _pir_next__arity_3
    stur x0, [x29, #-192]
    ldur x9, [x29, #-192]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-192]
    bl _pir_emit__arity_2
    stur x0, [x29, #-152]
    ldur x0, [x29, #-96]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-192]
    bl _pir_copy__arity_3
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-40]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_emit__arity_2
    stur x0, [x29, #-152]
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_decimal__arity_2
    stur x0, [x29, #-176]
    ldur x9, [x29, #-176]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
.set U,8
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-168]
    ldur x9, [x29, #-176]
    ldur x10, [x29, #-168]
    cmp x9, x10
    cset x11, ls
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_invalid
    ldur x9, [x29, #-88]
    ldur x10, [x29, #-8]
    ldur x11, [x29, #-8]
    add x9, x9, x10
    strb w11, [x9]
.set U,1
    movz x9,#(U&0xffff)
    .if (U>>16)&0xffff
    movk x9,#((U>>16)&0xffff),lsl #16
    .endif
    .if (U>>32)&0xffff
    movk x9,#((U>>32)&0xffff),lsl #32
    .endif
    .if (U>>48)&0xffff
    movk x9,#((U>>48)&0xffff),lsl #48
    .endif

    stur x9, [x29, #-72]
    b L_main_token
L_main_finish:
    ldur x9, [x29, #-72]
    cbnz x9, L_main_invalid
.set X,0
.if X>>8
.error "plang0: exit"
.endif
    movz x0,#X
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_main_limited:
    adrp x0, L_data_limited@PAGE
    add x0, x0, L_data_limited@PAGEOFF
    mov x1, #L_size_limited
    bl _plang_err
.set X,1
.if X>>8
.error "plang0: exit"
.endif
    movz x0,#X
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_main_invalid:
    adrp x0, L_data_invalid@PAGE
    add x0, x0, L_data_invalid@PAGEOFF
    mov x1, #L_size_invalid
    bl _plang_err
.set X,1
.if X>>8
.error "plang0: exit"
.endif
    movz x0,#X
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
