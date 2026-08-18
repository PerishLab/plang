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
L_data_usage:
    .ascii "plang0: source path required\n"
    .set L_size_usage, . - L_data_usage
.p2align 0
L_data_opened:
    .ascii "plang0: source open failed\n"
    .set L_size_opened, . - L_data_opened
.p2align 0
L_data_limited:
    .ascii "plang0: memory limit\n"
    .set L_size_limited, . - L_data_limited
.p2align 0
L_data_failed:
    .ascii "plang0: source read failed\n"
    .set L_size_failed, . - L_data_failed
.p2align 0
L_data_quoted:
    .ascii "plang0: unterminated string\n"
    .set L_size_quoted, . - L_data_quoted
.p2align 0
L_data_newline:
    .ascii "\n"
    .set L_size_newline, . - L_data_newline
.set L_a,1
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _pir_space
_pir_space__arity_1:
_pir_space:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #240
    .if 0>=L_a
    .error "plang0: arg index"
    .endif
    stur x0, [x29, #-8]
.set U,9
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

    stur x9, [x29, #-24]
.set U,13
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

    stur x9, [x29, #-40]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-16]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-48]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-56]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-56]
    orr x11, x9, x10
    stur x11, [x29, #-48]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-32]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-56]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-56]
    orr x11, x9, x10
    stur x11, [x29, #-48]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-40]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-56]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-56]
    orr x11, x9, x10
    stur x11, [x29, #-48]
    ldur x0, [x29, #-48]
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
.set L_a,2
.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _main
_main:
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

    stur x9, [x29, #-40]
.set U,35
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
.set U,34
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
.set U,92
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

    stur x9, [x29, #-88]
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

    stur x9, [x29, #-96]
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

    stur x9, [x29, #-104]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-40]
    cmp x9, x10
    cset x11, lo
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbnz x9, L_main_usage
    ldur x9, [x29, #-16]
    ldur x10, [x29, #-32]
    ldr x11, [x9, x10, lsl #3]
    stur x11, [x29, #-120]
    ldur x0, [x29, #-120]
    bl _plang_open
    stur x0, [x29, #-128]
    ldur x9, [x29, #-128]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, lt
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbnz x9, L_main_opened
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

    stur x9, [x29, #-136]
    ldur x0, [x29, #-136]
    bl _plang_alloc
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbz x9, L_main_limited
L_main_read:
    ldur x0, [x29, #-128]
    ldur x1, [x29, #-144]
    ldur x2, [x29, #-136]
    bl _plang_read
    stur x0, [x29, #-152]
    ldur x9, [x29, #-152]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, lt
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbnz x9, L_main_failed
    ldur x9, [x29, #-152]
    cbz x9, L_main_finish
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

    stur x9, [x29, #-160]
L_main_byte:
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbnz x9, L_main_read
    ldur x9, [x29, #-144]
    ldur x10, [x29, #-160]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-168]
    ldur x9, [x29, #-104]
    cbnz x9, L_main_comment
    ldur x9, [x29, #-88]
    cbnz x9, L_main_quote
    ldur x9, [x29, #-168]
    ldur x10, [x29, #-48]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbz x9, L_main_normal
    ldur x9, [x29, #-80]
    cbnz x9, L_main_normal
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

    stur x9, [x29, #-104]
    b L_main_next
L_main_comment:
    ldur x9, [x29, #-168]
    ldur x10, [x29, #-72]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbz x9, L_main_next
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

    stur x9, [x29, #-104]
    b L_main_next
L_main_quote:
    ldur x9, [x29, #-144]
    ldur x10, [x29, #-160]
    add x11, x9, x10
    stur x11, [x29, #-176]
    ldur x0, [x29, #-32]
    ldur x1, [x29, #-176]
    ldur x2, [x29, #-32]
    bl _plang_write
    stur x0, [x29, #-184]
    ldur x9, [x29, #-96]
    cbz x9, L_main_quote_slash
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

    stur x9, [x29, #-96]
    b L_main_next
L_main_quote_slash:
    ldur x9, [x29, #-168]
    ldur x10, [x29, #-64]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbz x9, L_main_quote_end
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

    stur x9, [x29, #-96]
    b L_main_next
L_main_quote_end:
    ldur x9, [x29, #-168]
    ldur x10, [x29, #-56]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbz x9, L_main_next
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

    stur x9, [x29, #-88]
    b L_main_next
L_main_normal:
    ldur x0, [x29, #-168]
    bl _pir_space__arity_1
    stur x0, [x29, #-112]
    ldur x9, [x29, #-112]
    cbz x9, L_main_mark
    ldur x9, [x29, #-80]
    cbz x9, L_main_next
    adrp x0, L_data_newline@PAGE
    add x0, x0, L_data_newline@PAGEOFF
    mov x1, #L_size_newline
    bl _plang_out
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
    b L_main_next
L_main_mark:
    ldur x9, [x29, #-168]
    ldur x10, [x29, #-56]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x9, [x29, #-112]
    cbz x9, L_main_emit
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

    stur x9, [x29, #-88]
L_main_emit:
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

    stur x9, [x29, #-80]
    ldur x9, [x29, #-144]
    ldur x10, [x29, #-160]
    add x11, x9, x10
    stur x11, [x29, #-176]
    ldur x0, [x29, #-32]
    ldur x1, [x29, #-176]
    ldur x2, [x29, #-32]
    bl _plang_write
    stur x0, [x29, #-184]
L_main_next:
    ldur x9, [x29, #-160]
    ldur x10, [x29, #-32]
    add x11, x9, x10
    stur x11, [x29, #-160]
    b L_main_byte
L_main_finish:
    ldur x0, [x29, #-128]
    bl _plang_close
    stur x0, [x29, #-192]
    ldur x9, [x29, #-88]
    cbnz x9, L_main_quoted
    ldur x9, [x29, #-80]
    cbz x9, L_main_success
    adrp x0, L_data_newline@PAGE
    add x0, x0, L_data_newline@PAGEOFF
    mov x1, #L_size_newline
    bl _plang_out
L_main_success:
.set X,0
.if X>>8
.error "plang0: exit"
.endif
    movz x0,#X
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_main_usage:
    adrp x0, L_data_usage@PAGE
    add x0, x0, L_data_usage@PAGEOFF
    mov x1, #L_size_usage
    bl _plang_err
.set X,1
.if X>>8
.error "plang0: exit"
.endif
    movz x0,#X
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_main_opened:
    adrp x0, L_data_opened@PAGE
    add x0, x0, L_data_opened@PAGEOFF
    mov x1, #L_size_opened
    bl _plang_err
.set X,1
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
L_main_failed:
    ldur x0, [x29, #-128]
    bl _plang_close
    stur x0, [x29, #-192]
    adrp x0, L_data_failed@PAGE
    add x0, x0, L_data_failed@PAGEOFF
    mov x1, #L_size_failed
    bl _plang_err
.set X,1
.if X>>8
.error "plang0: exit"
.endif
    movz x0,#X
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
L_main_quoted:
    adrp x0, L_data_quoted@PAGE
    add x0, x0, L_data_quoted@PAGEOFF
    mov x1, #L_size_quoted
    bl _plang_err
.set X,1
.if X>>8
.error "plang0: exit"
.endif
    movz x0,#X
    add sp, sp, #240
    ldp x29, x30, [sp], #16
    ret
