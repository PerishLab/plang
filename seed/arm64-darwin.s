.equ PLANG_MEMORY_LIMIT, 16777216

.section __TEXT,__text,regular,pure_instructions
.p2align 2
.globl _plang_alloc
_plang_alloc:
    adds x0, x0, #15
    b.cs L_alloc_fail
    and x0, x0, #0xfffffffffffffff0
    adrp x1, _plang_used@PAGE
    add x1, x1, _plang_used@PAGEOFF
    ldr x2, [x1]
    adds x3, x2, x0
    b.cs L_alloc_fail
    movz x4, #256, lsl #16
    cmp x3, x4
    b.hi L_alloc_fail
    str x3, [x1]
    adrp x0, _plang_arena@PAGE
    add x0, x0, _plang_arena@PAGEOFF
    add x0, x0, x2
    ret
L_alloc_fail:
    mov x0, #0
    ret

.globl _plang_out
_plang_out:
    mov x2, x1
    mov x1, x0
    mov x0, #1
    b _write

.globl _plang_err
_plang_err:
    mov x2, x1
    mov x1, x0
    mov x0, #2
    b _write

.globl _plang_memory_error
_plang_memory_error:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    adrp x0, L_memory_error@PAGE
    add x0, x0, L_memory_error@PAGEOFF
    mov x1, #20
    bl _plang_err
    mov w0, #1
    ldp x29, x30, [sp], #16
    ret

.globl _plang_open
_plang_open:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    mov x1, #0
    bl _open
    sxtw x0, w0
    ldp x29, x30, [sp], #16
    ret

.globl _plang_close
_plang_close:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    bl _close
    sxtw x0, w0
    ldp x29, x30, [sp], #16
    ret

.globl _plang_read
_plang_read:
    b _read

.globl _plang_write
_plang_write:
    b _write

.section __TEXT,__const
L_memory_error:
    .ascii "plang: memory limit\n"

.section __DATA,__data
.p2align 3
_plang_used:
    .quad 0

.section __DATA,__bss
.p2align 4
_plang_arena:
    .space PLANG_MEMORY_LIMIT
