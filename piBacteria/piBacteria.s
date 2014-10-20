        .set    MBOXBASE,   0x2000B880
        .set    MBOXREAD,   0x00
        .set    MBOXSTATUS, 0x18
        .set    MBOXWRITE,  0x20
        .set    MEMORY,     endf
        .set    LTABLE,     endf+0x10000
.text
        iyi     .req      r0
        mem     .req      r1
        stlo    .req      r2
        pcff    .req      r3
        spfa    .req      r4
        bcfb    .req      r5
        defr    .req      r6
        hlmp    .req      r7
        arvpref .req      r8
        ix      .req      r9

@ Esto es para configurar el buffer de video a 352x264x4
        ldr     r0, fbinf
        add     r0, #0x40000001
        ldr     r1, mboxb
wait1:  ldr     r2, [r1, #MBOXSTATUS]
        tst     r2, #0x80000000
        bne     wait1
        str     r0, [r1, #MBOXWRITE]
wait2:  ldr     r2, [r1, #MBOXSTATUS]
        tst     r2, #0x40000000
        bne     wait2
        ldr     r2, [r1, #MBOXREAD]
        and     r2, #0x0000000f
        cmp     r2, #1
        bne     wait2

@ Esto es para crear las tablas de pintado rápido
        ldr     r6, ltabl
        add     r6, #0x20000
        mov     r0, #127
gent1:  mov     r1, #255
gent2:  and     r3, r0, #7
        tst     r0, #0b01000000
        orrne   r3, #8
        mov     r2, r0, lsr #3
        add     r4, r1, #0x00008000
gent3:  tst     r4, #0x02
        mov     r5, r5, lsl #4
        addeq   r5, r2
        addne   r5, r3
        tst     r4, #0x01
        mov     r5, r5, lsl #4
        addeq   r5, r2
        addne   r5, r3
        mov     r4, r4, lsr #2
        tst     r4, #0x0000ff00
        bne     gent3
        str     r5, [r6, #-4]!
        subs    r1, #1
        bpl     gent2
        subs    r0, #1
        bpl     gent1

@ Esto renderiza la imagen

        ldr     r4, c7777
        ldr     r8, screen
        ldr     r0, fbinf
render: ldr     r1, [r0, #32]
        mov     r2, #0
drawr:  mov     r3, #0
drawp:  sub     r5, r3, #6
        cmp     r5, #32
        bcs     aqui
        sub     r7, r2, #36
        cmp     r7, #192
        bcs     aqui
        and     r9, r7, #0b11111000
        orr     r9, r5, r9, lsl #2
        add     r9, #6144
        ldrb    r9, [r8, r9]
        add     r5, r7, lsl #5
        bic     r5, #0b0011111100000
        and     r10, r7, #0b00111000
        orr     r5, r10, lsl #2
        and     r7, #0b00000111
        orr     r5, r7, lsl #8
        ldrb    r5, [r8, r5]
        add     r5, r5, r9, lsl #8
        ldr     r5, [r6, r5, lsl #2]
        str     r5, [r1], #4
aqui:   strcs   r4, [r1], #4
        add     r3, #1
        cmp     r3, #44
        bne     drawp
        add     r2, #1
        cmp     r2, #264
        bne     drawr
inf:    b       inf
@ piscina de constantes
fa_:    .short  0
fb_:    .short  0
ff_:    .short  0
fr_:    .short  0
c_:     .byte   0
b_:     .byte   0
e_:     .byte   0
d_:     .byte   0
dummy1: .short  0
l_:     .byte   0
h_:     .byte   0
a_:     .word   0
fbinf:  .word   FrameBufferInfo
mboxb:  .word   MBOXBASE
ltabl:  .word   LTABLE
screen: .word   MEMORY+0x4000

in:     bx      lr
out:    bx      lr

        .include  "z80.s"
        .balign 16
FrameBufferInfo:
        .word   1024    @0 Width
        .word   768     @4 Height
        .word   352     @8 vWidth
        .word   264     @12 vHeight
        .word   0       @16 GPU - Pitch
        .word   4       @20 Bit Dpeth
        .word   0       @24 X
        .word   0       @28 Y
        .word   0       @32 GPU - Pointer
        .word   0       @36 GPU - Size
                 @rrrrrggggggbbbbb
        .hword  0b0000000000000000
        .hword  0b0000000000010111
        .hword  0b1011100000000000
        .hword  0b1011100000010111
        .hword  0b0000010111100000
        .hword  0b0000010111110111
        .hword  0b1011110111100000
        .hword  0b1011110111110111
        .hword  0b0000000000000000
        .hword  0b0000000000011111
        .hword  0b1111100000000000
        .hword  0b1111100000011111
        .hword  0b0000011111100000
        .hword  0b0000011111111111
        .hword  0b1111111111100000
        .hword  0b1111111111111111

endf:   .incbin "48.rom"
        .incbin "gameover.scr"

