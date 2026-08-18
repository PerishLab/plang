.section __TEXT,__const
.set M,32768
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
    .space 32768
.section __TEXT,__const
.p2align 0
L_data_top:
    .ascii "memory M\nbytes B\nfunc F\n"
    .set L_size_top, . - L_data_top
.p2align 0
L_data_body:
    .ascii "arg A\nu64 U\ndata D\nfuncptr F\nadd B\nsub B\nmul B\nand B\nor B\nxor B\nshl B\nshr B\neq P\nne P\nlt P\nle P\nslt P\nload8 L\nload64 Q\nstore8 H\nstore64 V\nalloc C\nargv R\nread I\nwrite I\nopen N\nclose N\ncall K\ninvoke Y\nlabel G\njump J\nzero Z\nnonzero Z\nout O\nerr O\nexit X\nret T\nend E\n"
    .set L_size_body, . - L_data_body
.p2align 0
L_data_constsec:
    .ascii ".section __TEXT,__const\n"
    .set L_size_constsec, . - L_data_constsec
.p2align 0
L_data_memorya:
    .ascii ".set M,"
    .set L_size_memorya, . - L_data_memorya
.p2align 0
L_data_memoryb:
    .ascii "\n.if (M&(M-1))||(M<4096)||(M>>25)\n.error \"plang0: memory\"\n.endif\n.section __DATA,__data\n.p2align 3\n.globl _plang_memory_limit\n_plang_memory_limit:\n    .quad M\n.section __DATA,__bss\n.p2align 4\n.globl _plang_arena\n_plang_arena:\n    .space "
    .set L_size_memoryb, . - L_data_memoryb
.p2align 0
L_data_datahead:
    .ascii ".p2align 0\nL_data_"
    .set L_size_datahead, . - L_data_datahead
.p2align 0
L_data_datamid:
    .ascii ":\n    .ascii "
    .set L_size_datamid, . - L_data_datamid
.p2align 0
L_data_dataset:
    .ascii "\n    .set L_size_"
    .set L_size_dataset, . - L_data_dataset
.p2align 0
L_data_dataend:
    .ascii ", . - L_data_"
    .set L_size_dataend, . - L_data_dataend
.p2align 0
L_data_line:
    .ascii "\n"
    .set L_size_line, . - L_data_line
.p2align 0
L_data_texthead:
    .ascii ".section __TEXT,__text,regular,pure_instructions\n.p2align 2\n.globl "
    .set L_size_texthead, . - L_data_texthead
.p2align 0
L_data_mainname:
    .ascii "_main"
    .set L_size_mainname, . - L_data_mainname
.p2align 0
L_data_pirname:
    .ascii "_pir_"
    .set L_size_pirname, . - L_data_pirname
.p2align 0
L_data_aritymid:
    .ascii "__arity_"
    .set L_size_aritymid, . - L_data_aritymid
.p2align 0
L_data_prologue:
    .ascii ":\n    stp x29, x30, [sp, #-16]!\n    mov x29, sp\n    sub sp, sp, #240\n"
    .set L_size_prologue, . - L_data_prologue
.p2align 0
L_data_arityset:
    .ascii ".set L_a,"
    .set L_size_arityset, . - L_data_arityset
.p2align 0
L_data_argchecka:
    .ascii "    .if "
    .set L_size_argchecka, . - L_data_argchecka
.p2align 0
L_data_argcheckb:
    .ascii ">=L_a\n    .error \"plang0: arg index\"\n    .endif\n"
    .set L_size_argcheckb, . - L_data_argcheckb
.p2align 0
L_data_movz:
    .ascii ".set U,"
    .set L_size_movz, . - L_data_movz
.p2align 0
L_data_immlow:
    .ascii "\n    movz x9,#(U&0xffff)\n"
    .set L_size_immlow, . - L_data_immlow
.p2align 0
L_data_imm16a:
    .ascii "    .if (U>>16)&0xffff\n    movk x9,#((U>>16)&0xffff),lsl #16\n    .endif\n"
    .set L_size_imm16a, . - L_data_imm16a
.p2align 0
L_data_imm32b:
    .ascii "    .if (U>>32)&0xffff\n    movk x9,#((U>>32)&0xffff),lsl #32\n    .endif\n"
    .set L_size_imm32b, . - L_data_imm32b
.p2align 0
L_data_imm48b:
    .ascii "    .if (U>>48)&0xffff\n    movk x9,#((U>>48)&0xffff),lsl #48\n    .endif\n"
    .set L_size_imm48b, . - L_data_imm48b
.p2align 0
L_data_arghead:
    .ascii "    stur x"
    .set L_size_arghead, . - L_data_arghead
.p2align 0
L_data_store:
    .ascii "\n    stur x9, [x29, #-"
    .set L_size_store, . - L_data_store
.p2align 0
L_data_store0:
    .ascii "    stur x0, [x29, #-"
    .set L_size_store0, . - L_data_store0
.p2align 0
L_data_store11:
    .ascii "    stur x11, [x29, #-"
    .set L_size_store11, . - L_data_store11
.p2align 0
L_data_close:
    .ascii "]\n"
    .set L_size_close, . - L_data_close
.p2align 0
L_data_load0:
    .ascii "    ldur x0, [x29, #-"
    .set L_size_load0, . - L_data_load0
.p2align 0
L_data_load1:
    .ascii "    ldur x1, [x29, #-"
    .set L_size_load1, . - L_data_load1
.p2align 0
L_data_load2:
    .ascii "    ldur x2, [x29, #-"
    .set L_size_load2, . - L_data_load2
.p2align 0
L_data_load3:
    .ascii "    ldur x3, [x29, #-"
    .set L_size_load3, . - L_data_load3
.p2align 0
L_data_load4:
    .ascii "    ldur x4, [x29, #-"
    .set L_size_load4, . - L_data_load4
.p2align 0
L_data_load5:
    .ascii "    ldur x5, [x29, #-"
    .set L_size_load5, . - L_data_load5
.p2align 0
L_data_load6:
    .ascii "    ldur x6, [x29, #-"
    .set L_size_load6, . - L_data_load6
.p2align 0
L_data_load7:
    .ascii "    ldur x7, [x29, #-"
    .set L_size_load7, . - L_data_load7
.p2align 0
L_data_load10:
    .ascii "    ldur x10, [x29, #-"
    .set L_size_load10, . - L_data_load10
.p2align 0
L_data_load11:
    .ascii "    ldur x11, [x29, #-"
    .set L_size_load11, . - L_data_load11
.p2align 0
L_data_alloc:
    .ascii "    bl _plang_alloc\n    stur x0, [x29, #-"
    .set L_size_alloc, . - L_data_alloc
.p2align 0
L_data_load9:
    .ascii "    ldur x9, [x29, #-"
    .set L_size_load9, . - L_data_load9
.p2align 0
L_data_add11:
    .ascii "    add x11, x9, x10\n"
    .set L_size_add11, . - L_data_add11
.p2align 0
L_data_sub11:
    .ascii "    sub x11, x9, x10\n"
    .set L_size_sub11, . - L_data_sub11
.p2align 0
L_data_mul11:
    .ascii "    mul x11, x9, x10\n"
    .set L_size_mul11, . - L_data_mul11
.p2align 0
L_data_and11:
    .ascii "    and x11, x9, x10\n"
    .set L_size_and11, . - L_data_and11
.p2align 0
L_data_or11:
    .ascii "    orr x11, x9, x10\n"
    .set L_size_or11, . - L_data_or11
.p2align 0
L_data_xor11:
    .ascii "    eor x11, x9, x10\n"
    .set L_size_xor11, . - L_data_xor11
.p2align 0
L_data_shl11:
    .ascii "    lsl x11, x9, x10\n"
    .set L_size_shl11, . - L_data_shl11
.p2align 0
L_data_shr11:
    .ascii "    lsr x11, x9, x10\n"
    .set L_size_shr11, . - L_data_shr11
.p2align 0
L_data_cmp:
    .ascii "    cmp x9, x10\n    cset x11, "
    .set L_size_cmp, . - L_data_cmp
.p2align 0
L_data_eqcond:
    .ascii "eq\n"
    .set L_size_eqcond, . - L_data_eqcond
.p2align 0
L_data_necond:
    .ascii "ne\n"
    .set L_size_necond, . - L_data_necond
.p2align 0
L_data_ltcond:
    .ascii "lo\n"
    .set L_size_ltcond, . - L_data_ltcond
.p2align 0
L_data_lecond:
    .ascii "ls\n"
    .set L_size_lecond, . - L_data_lecond
.p2align 0
L_data_sltcond:
    .ascii "lt\n"
    .set L_size_sltcond, . - L_data_sltcond
.p2align 0
L_data_argvload:
    .ascii "    ldr x11, [x9, x10, lsl #3]\n"
    .set L_size_argvload, . - L_data_argvload
.p2align 0
L_data_loadbyte:
    .ascii "    add x11, x9, x10\n    ldrb w11, [x11]\n"
    .set L_size_loadbyte, . - L_data_loadbyte
.p2align 0
L_data_loadword:
    .ascii "    add x11, x9, x10\n    ldr x11, [x11]\n"
    .set L_size_loadword, . - L_data_loadword
.p2align 0
L_data_storebyte:
    .ascii "    add x9, x9, x10\n    strb w11, [x9]\n"
    .set L_size_storebyte, . - L_data_storebyte
.p2align 0
L_data_storeword:
    .ascii "    add x9, x9, x10\n    str x11, [x9]\n"
    .set L_size_storeword, . - L_data_storeword
.p2align 0
L_data_dataa:
    .ascii "    adrp x9, L_data_"
    .set L_size_dataa, . - L_data_dataa
.p2align 0
L_data_datab:
    .ascii "@PAGE\n    add x9, x9, L_data_"
    .set L_size_datab, . - L_data_datab
.p2align 0
L_data_datac:
    .ascii "@PAGEOFF\n    stur x9, [x29, #-"
    .set L_size_datac, . - L_data_datac
.p2align 0
L_data_datad:
    .ascii "]\n    mov x9, #L_size_"
    .set L_size_datad, . - L_data_datad
.p2align 0
L_data_datae:
    .ascii "\n    stur x9, [x29, #-"
    .set L_size_datae, . - L_data_datae
.p2align 0
L_data_funca:
    .ascii "    adrp x9, _pir_"
    .set L_size_funca, . - L_data_funca
.p2align 0
L_data_funcb:
    .ascii "@PAGE\n    add x9, x9, _pir_"
    .set L_size_funcb, . - L_data_funcb
.p2align 0
L_data_funcc:
    .ascii "@PAGEOFF\n    stur x9, [x29, #-"
    .set L_size_funcc, . - L_data_funcc
.p2align 0
L_data_calla:
    .ascii "    bl _pir_"
    .set L_size_calla, . - L_data_calla
.p2align 0
L_data_blr:
    .ascii "    blr x9\n"
    .set L_size_blr, . - L_data_blr
.p2align 0
L_data_runtimea:
    .ascii "    bl _plang_"
    .set L_size_runtimea, . - L_data_runtimea
.p2align 0
L_data_readcall:
    .ascii "    bl _plang_read\n"
    .set L_size_readcall, . - L_data_readcall
.p2align 0
L_data_writecall:
    .ascii "    bl _plang_write\n"
    .set L_size_writecall, . - L_data_writecall
.p2align 0
L_data_opencall:
    .ascii "    bl _plang_open\n"
    .set L_size_opencall, . - L_data_opencall
.p2align 0
L_data_closecall:
    .ascii "    bl _plang_close\n"
    .set L_size_closecall, . - L_data_closecall
.p2align 0
L_data_labela:
    .ascii "L_"
    .set L_size_labela, . - L_data_labela
.p2align 0
L_data_labelb:
    .ascii ":\n"
    .set L_size_labelb, . - L_data_labelb
.p2align 0
L_data_jumpa:
    .ascii "    b L_"
    .set L_size_jumpa, . - L_data_jumpa
.p2align 0
L_data_cbza:
    .ascii "]\n    cbz x9, L_"
    .set L_size_cbza, . - L_data_cbza
.p2align 0
L_data_cbnza:
    .ascii "]\n    cbnz x9, L_"
    .set L_size_cbnza, . - L_data_cbnza
.p2align 0
L_data_outa:
    .ascii "    adrp x0, L_data_"
    .set L_size_outa, . - L_data_outa
.p2align 0
L_data_outb:
    .ascii "@PAGE\n    add x0, x0, L_data_"
    .set L_size_outb, . - L_data_outb
.p2align 0
L_data_outc:
    .ascii "@PAGEOFF\n    mov x1, #L_size_"
    .set L_size_outc, . - L_data_outc
.p2align 0
L_data_outd:
    .ascii "\n    bl _plang_"
    .set L_size_outd, . - L_data_outd
.p2align 0
L_data_exita:
    .ascii ".set X,"
    .set L_size_exita, . - L_data_exita
.p2align 0
L_data_exitb:
    .ascii "\n.if X>>8\n.error \"plang0: exit\"\n.endif\n    movz x0,#X\n"
    .set L_size_exitb, . - L_data_exitb
.p2align 0
L_data_epilogue:
    .ascii "    add sp, sp, #240\n    ldp x29, x30, [sp], #16\n    ret\n"
    .set L_size_epilogue, . - L_data_epilogue
.p2align 0
L_data_comma:
    .ascii ", [x29, #-"
    .set L_size_comma, . - L_data_comma
.p2align 0
L_data_mainword:
    .ascii "main"
    .set L_size_mainword, . - L_data_mainword
.p2align 0
L_data_limited:
    .ascii "plang0: memory limit\n"
    .set L_size_limited, . - L_data_limited
.p2align 0
L_data_invalid:
    .ascii "plang0: emitter rejected token stream\n"
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
    ldur x0, [x29, #-88]
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
.globl _pir_reg
_pir_reg__arity_2:
_pir_reg:
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

    stur x9, [x29, #-24]
    ldur x9, [x29, #-16]
    ldur x10, [x29, #-24]
    sub x11, x9, x10
    stur x11, [x29, #-16]
    ldur x9, [x29, #-8]
    ldur x10, [x29, #-24]
    add x11, x9, x10
    stur x11, [x29, #-8]
    ldur x0, [x29, #-8]
    ldur x1, [x29, #-16]
    bl _pir_put__arity_2
    stur x0, [x29, #-32]
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

    stur x9, [x29, #-24]
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

    stur x9, [x29, #-32]
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
    ldur x0, [x29, #-32]
    bl _plang_alloc
    stur x0, [x29, #-48]
    ldur x0, [x29, #-32]
    bl _plang_alloc
    stur x0, [x29, #-56]
    ldur x0, [x29, #-32]
    bl _plang_alloc
    stur x0, [x29, #-64]
    ldur x0, [x29, #-32]
    bl _plang_alloc
    stur x0, [x29, #-72]
    ldur x0, [x29, #-32]
    bl _plang_alloc
    stur x0, [x29, #-80]
    ldur x9, [x29, #-48]
    cbz x9, L_main_limited
    ldur x9, [x29, #-56]
    cbz x9, L_main_limited
    ldur x9, [x29, #-64]
    cbz x9, L_main_limited
    ldur x9, [x29, #-72]
    cbz x9, L_main_limited
    ldur x9, [x29, #-80]
    cbz x9, L_main_limited
    adrp x9, L_data_top@PAGE
    add x9, x9, L_data_top@PAGEOFF
    stur x9, [x29, #-88]
    mov x9, #L_size_top
    stur x9, [x29, #-96]
    adrp x9, L_data_constsec@PAGE
    add x9, x9, L_data_constsec@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_constsec
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
L_main_top:
    adrp x9, L_data_top@PAGE
    add x9, x9, L_data_top@PAGEOFF
    stur x9, [x29, #-88]
    mov x9, #L_size_top
    stur x9, [x29, #-96]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    ldur x9, [x29, #-128]
    cbz x9, L_main_success
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-128]
    ldur x2, [x29, #-88]
    ldur x3, [x29, #-96]
    bl _pir_lookup__arity_4
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-24]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
.set U,77
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_memory
.set U,66
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_bytes
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_function
    b L_main_invalid
L_main_memory:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    ldur x9, [x29, #-128]
    cbz x9, L_main_invalid
    adrp x9, L_data_memorya@PAGE
    add x9, x9, L_data_memorya@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_memorya
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-128]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_memoryb@PAGE
    add x9, x9, L_data_memoryb@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_memoryb
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-128]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_constsec@PAGE
    add x9, x9, L_data_constsec@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_constsec
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_top
L_main_bytes:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x9, [x29, #-160]
    cbz x9, L_main_invalid
    ldur x9, [x29, #-168]
    cbz x9, L_main_invalid
    adrp x9, L_data_datahead@PAGE
    add x9, x9, L_data_datahead@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_datahead
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_datamid@PAGE
    add x9, x9, L_data_datamid@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_datamid
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_dataset@PAGE
    add x9, x9, L_data_dataset@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_dataset
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_dataend@PAGE
    add x9, x9, L_data_dataend@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_dataend
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_top
L_main_function:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x9, [x29, #-160]
    cbz x9, L_main_invalid
    ldur x9, [x29, #-168]
    cbz x9, L_main_invalid
    adrp x9, L_data_arityset@PAGE
    add x9, x9, L_data_arityset@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_arityset
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_texthead@PAGE
    add x9, x9, L_data_texthead@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_texthead
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_mainword@PAGE
    add x9, x9, L_data_mainword@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_mainword
    stur x9, [x29, #-112]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    ldur x2, [x29, #-104]
    ldur x3, [x29, #-112]
    bl _pir_same__arity_4
    stur x0, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_function_main
    adrp x9, L_data_pirname@PAGE
    add x9, x9, L_data_pirname@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_pirname
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_pirname@PAGE
    add x9, x9, L_data_pirname@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_pirname
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_aritymid@PAGE
    add x9, x9, L_data_aritymid@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_aritymid
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_labelb@PAGE
    add x9, x9, L_data_labelb@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_labelb
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_pirname@PAGE
    add x9, x9, L_data_pirname@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_pirname
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_function_tail
L_main_function_main:
    adrp x9, L_data_mainname@PAGE
    add x9, x9, L_data_mainname@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_mainname
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_mainname@PAGE
    add x9, x9, L_data_mainname@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_mainname
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
L_main_function_tail:
    adrp x9, L_data_prologue@PAGE
    add x9, x9, L_data_prologue@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_prologue
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
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

    stur x9, [x29, #-176]
    adrp x9, L_data_body@PAGE
    add x9, x9, L_data_body@PAGEOFF
    stur x9, [x29, #-88]
    mov x9, #L_size_body
    stur x9, [x29, #-96]
L_main_body:
    adrp x9, L_data_body@PAGE
    add x9, x9, L_data_body@PAGEOFF
    stur x9, [x29, #-88]
    mov x9, #L_size_body
    stur x9, [x29, #-96]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    ldur x9, [x29, #-128]
    cbz x9, L_main_invalid
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-128]
    ldur x2, [x29, #-88]
    ldur x3, [x29, #-96]
    bl _pir_lookup__arity_4
    stur x0, [x29, #-136]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-24]
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_finish
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

    stur x9, [x29, #-176]
.set U,65
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_arg
.set U,85
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_u64
.set U,68
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_data
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_function_pointer
.set U,66
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary
.set U,80
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_compare
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_load8
.set U,81
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_load64
.set U,72
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_store8
.set U,86
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_store64
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_allocation
.set U,82
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_argv
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_io
.set U,78
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_unary_runtime
.set U,75
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call
.set U,89
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call
.set U,71
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_label
.set U,74
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_jump
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_branch
.set U,79
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_output
.set U,88
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_exit
.set U,84
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-136]
    ldur x10, [x29, #-152]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_return_op
    b L_main_invalid
L_main_arg:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    adrp x9, L_data_argchecka@PAGE
    add x9, x9, L_data_argchecka@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_argchecka
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_argcheckb@PAGE
    add x9, x9, L_data_argcheckb@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_argcheckb
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_arghead@PAGE
    add x9, x9, L_data_arghead@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_arghead
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_comma@PAGE
    add x9, x9, L_data_comma@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_comma
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_u64:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x9, [x29, #-64]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,45
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
    adrp x9, L_data_movz@PAGE
    add x9, x9, L_data_movz@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_movz
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_immlow@PAGE
    add x9, x9, L_data_immlow@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_immlow
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_imm16a@PAGE
    add x9, x9, L_data_imm16a@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_imm16a
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_imm32b@PAGE
    add x9, x9, L_data_imm32b@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_imm32b
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_imm48b@PAGE
    add x9, x9, L_data_imm48b@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_imm48b
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store@PAGE
    add x9, x9, L_data_store@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_data:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_dataa@PAGE
    add x9, x9, L_data_dataa@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_dataa
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_datab@PAGE
    add x9, x9, L_data_datab@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_datab
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_datac@PAGE
    add x9, x9, L_data_datac@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_datac
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_datad@PAGE
    add x9, x9, L_data_datad@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_datad
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_datae@PAGE
    add x9, x9, L_data_datae@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_datae
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_function_pointer:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    adrp x9, L_data_funca@PAGE
    add x9, x9, L_data_funca@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_funca
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_funcb@PAGE
    add x9, x9, L_data_funcb@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_funcb
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_funcc@PAGE
    add x9, x9, L_data_funcc@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_funcc
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_binary:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load10@PAGE
    add x9, x9, L_data_load10@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load10
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,97
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary_a
.set U,109
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary_mul
.set U,111
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary_or
.set U,120
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary_xor
    b L_main_binary_s
L_main_binary_a:
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-16]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,100
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary_add
    adrp x9, L_data_and11@PAGE
    add x9, x9, L_data_and11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_and11
    stur x9, [x29, #-112]
    b L_main_binary_emit
L_main_binary_add:
    adrp x9, L_data_add11@PAGE
    add x9, x9, L_data_add11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_add11
    stur x9, [x29, #-112]
    b L_main_binary_emit
L_main_binary_mul:
    adrp x9, L_data_mul11@PAGE
    add x9, x9, L_data_mul11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_mul11
    stur x9, [x29, #-112]
    b L_main_binary_emit
L_main_binary_or:
    adrp x9, L_data_or11@PAGE
    add x9, x9, L_data_or11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_or11
    stur x9, [x29, #-112]
    b L_main_binary_emit
L_main_binary_xor:
    adrp x9, L_data_xor11@PAGE
    add x9, x9, L_data_xor11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_xor11
    stur x9, [x29, #-112]
    b L_main_binary_emit
L_main_binary_s:
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-16]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,117
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary_sub
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

    stur x9, [x29, #-152]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-152]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,108
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_binary_shl
    adrp x9, L_data_shr11@PAGE
    add x9, x9, L_data_shr11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_shr11
    stur x9, [x29, #-112]
    b L_main_binary_emit
L_main_binary_sub:
    adrp x9, L_data_sub11@PAGE
    add x9, x9, L_data_sub11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_sub11
    stur x9, [x29, #-112]
    b L_main_binary_emit
L_main_binary_shl:
    adrp x9, L_data_shl11@PAGE
    add x9, x9, L_data_shl11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_shl11
    stur x9, [x29, #-112]
L_main_binary_emit:
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store11@PAGE
    add x9, x9, L_data_store11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store11
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_compare:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load10@PAGE
    add x9, x9, L_data_load10@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load10
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_cmp@PAGE
    add x9, x9, L_data_cmp@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_cmp
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,101
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_compare_eq
.set U,110
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_compare_ne
.set U,108
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_compare_l
    adrp x9, L_data_sltcond@PAGE
    add x9, x9, L_data_sltcond@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_sltcond
    stur x9, [x29, #-112]
    b L_main_compare_emit
L_main_compare_eq:
    adrp x9, L_data_eqcond@PAGE
    add x9, x9, L_data_eqcond@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_eqcond
    stur x9, [x29, #-112]
    b L_main_compare_emit
L_main_compare_ne:
    adrp x9, L_data_necond@PAGE
    add x9, x9, L_data_necond@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_necond
    stur x9, [x29, #-112]
    b L_main_compare_emit
L_main_compare_l:
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-16]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,116
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_compare_lt
L_main_compare_le:
    adrp x9, L_data_lecond@PAGE
    add x9, x9, L_data_lecond@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_lecond
    stur x9, [x29, #-112]
    b L_main_compare_emit
L_main_compare_lt:
    adrp x9, L_data_ltcond@PAGE
    add x9, x9, L_data_ltcond@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_ltcond
    stur x9, [x29, #-112]
L_main_compare_emit:
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store11@PAGE
    add x9, x9, L_data_store11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store11
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_load8:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load10@PAGE
    add x9, x9, L_data_load10@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load10
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_loadbyte@PAGE
    add x9, x9, L_data_loadbyte@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_loadbyte
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store11@PAGE
    add x9, x9, L_data_store11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store11
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_store8:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load10@PAGE
    add x9, x9, L_data_load10@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load10
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load11@PAGE
    add x9, x9, L_data_load11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load11
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_storebyte@PAGE
    add x9, x9, L_data_storebyte@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_storebyte
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_load64:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load10@PAGE
    add x9, x9, L_data_load10@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load10
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_loadword@PAGE
    add x9, x9, L_data_loadword@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_loadword
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store11@PAGE
    add x9, x9, L_data_store11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store11
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_store64:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load10@PAGE
    add x9, x9, L_data_load10@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load10
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load11@PAGE
    add x9, x9, L_data_load11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load11
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_storeword@PAGE
    add x9, x9, L_data_storeword@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_storeword
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_allocation:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    adrp x9, L_data_load0@PAGE
    add x9, x9, L_data_load0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_alloc@PAGE
    add x9, x9, L_data_alloc@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_alloc
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_argv:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load10@PAGE
    add x9, x9, L_data_load10@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load10
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_argvload@PAGE
    add x9, x9, L_data_argvload@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_argvload
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store11@PAGE
    add x9, x9, L_data_store11@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store11
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_unary_runtime:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    adrp x9, L_data_load0@PAGE
    add x9, x9, L_data_load0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,111
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_unary_open
    adrp x9, L_data_closecall@PAGE
    add x9, x9, L_data_closecall@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_closecall
    stur x9, [x29, #-112]
    b L_main_unary_emit
L_main_unary_open:
    adrp x9, L_data_opencall@PAGE
    add x9, x9, L_data_opencall@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_opencall
    stur x9, [x29, #-112]
L_main_unary_emit:
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store0@PAGE
    add x9, x9, L_data_store0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_io:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-80]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load0@PAGE
    add x9, x9, L_data_load0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load1@PAGE
    add x9, x9, L_data_load1@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load1
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_load2@PAGE
    add x9, x9, L_data_load2@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load2
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-80]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,114
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_io_read
    adrp x9, L_data_writecall@PAGE
    add x9, x9, L_data_writecall@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_writecall
    stur x9, [x29, #-112]
    b L_main_io_emit
L_main_io_read:
    adrp x9, L_data_readcall@PAGE
    add x9, x9, L_data_readcall@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_readcall
    stur x9, [x29, #-112]
L_main_io_emit:
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_store0@PAGE
    add x9, x9, L_data_store0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_call:
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,105
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-152]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-72]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-128]
    ldur x9, [x29, #-72]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_emit
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load0@PAGE
    add x9, x9, L_data_load0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,49
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_emit
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load1@PAGE
    add x9, x9, L_data_load1@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load1
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,50
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_emit
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load2@PAGE
    add x9, x9, L_data_load2@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load2
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,51
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_emit
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load3@PAGE
    add x9, x9, L_data_load3@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load3
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,52
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_arg4
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load4@PAGE
    add x9, x9, L_data_load4@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load4
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,53
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_arg5
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load5@PAGE
    add x9, x9, L_data_load5@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load5
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,54
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_arg6
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load6@PAGE
    add x9, x9, L_data_load6@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load6
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,55
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_call_arg7
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-48]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-136]
    adrp x9, L_data_load7@PAGE
    add x9, x9, L_data_load7@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load7
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-136]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
.set U,56
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, ne
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_invalid
L_main_call_arg7:
L_main_call_arg6:
L_main_call_arg5:
L_main_call_arg4:
L_main_call_emit:
    ldur x9, [x29, #-152]
    cbnz x9, L_main_invoke_emit
    adrp x9, L_data_calla@PAGE
    add x9, x9, L_data_calla@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_calla
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_aritymid@PAGE
    add x9, x9, L_data_aritymid@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_aritymid
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-72]
    ldur x1, [x29, #-128]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_call_store
L_main_invoke_emit:
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_blr@PAGE
    add x9, x9, L_data_blr@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_blr
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
L_main_call_store:
    adrp x9, L_data_store0@PAGE
    add x9, x9, L_data_store0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_store0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_branch:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-64]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-168]
    adrp x9, L_data_load9@PAGE
    add x9, x9, L_data_load9@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load9
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    ldur x9, [x29, #-48]
    ldur x10, [x29, #-8]
    add x11, x9, x10
    ldrb w11, [x11]
    stur x11, [x29, #-184]
.set U,122
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

    stur x9, [x29, #-192]
    ldur x9, [x29, #-184]
    ldur x10, [x29, #-192]
    cmp x9, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x9, [x29, #-144]
    cbnz x9, L_main_branch_zero
    adrp x9, L_data_cbnza@PAGE
    add x9, x9, L_data_cbnza@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_cbnza
    stur x9, [x29, #-112]
    b L_main_branch_emit
L_main_branch_zero:
    adrp x9, L_data_cbza@PAGE
    add x9, x9, L_data_cbza@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_cbza
    stur x9, [x29, #-112]
L_main_branch_emit:
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-64]
    ldur x1, [x29, #-168]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_output:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    adrp x9, L_data_outa@PAGE
    add x9, x9, L_data_outa@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_outa
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_outb@PAGE
    add x9, x9, L_data_outb@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_outb
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_outc@PAGE
    add x9, x9, L_data_outc@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_outc
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_outd@PAGE
    add x9, x9, L_data_outd@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_outd
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-48]
    ldur x1, [x29, #-128]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_label:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    adrp x9, L_data_labela@PAGE
    add x9, x9, L_data_labela@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_labela
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_labelb@PAGE
    add x9, x9, L_data_labelb@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_labelb
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_jump:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    adrp x9, L_data_jumpa@PAGE
    add x9, x9, L_data_jumpa@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_jumpa
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_line@PAGE
    add x9, x9, L_data_line@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_line
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    b L_main_body
L_main_exit:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    adrp x9, L_data_exita@PAGE
    add x9, x9, L_data_exita@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_exita
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_exitb@PAGE
    add x9, x9, L_data_exitb@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_exitb
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_epilogue@PAGE
    add x9, x9, L_data_epilogue@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_epilogue
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
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

    stur x9, [x29, #-176]
    b L_main_body
L_main_return_op:
    ldur x0, [x29, #-40]
    ldur x1, [x29, #-56]
    ldur x2, [x29, #-32]
    bl _pir_next__arity_3
    stur x0, [x29, #-160]
    adrp x9, L_data_load0@PAGE
    add x9, x9, L_data_load0@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_load0
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    ldur x0, [x29, #-56]
    ldur x1, [x29, #-160]
    bl _pir_reg__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_close@PAGE
    add x9, x9, L_data_close@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_close
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
    adrp x9, L_data_epilogue@PAGE
    add x9, x9, L_data_epilogue@PAGEOFF
    stur x9, [x29, #-104]
    mov x9, #L_size_epilogue
    stur x9, [x29, #-112]
    ldur x0, [x29, #-104]
    ldur x1, [x29, #-112]
    bl _pir_put__arity_2
    stur x0, [x29, #-120]
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

    stur x9, [x29, #-176]
    b L_main_body
L_main_finish:
    ldur x9, [x29, #-176]
    cbz x9, L_main_invalid
    b L_main_top
L_main_success:
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
