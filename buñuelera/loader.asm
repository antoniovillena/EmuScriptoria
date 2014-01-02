        include defload.asm
        DEFINE  border_loading 0
      IF  smooth=0
        DEFINE  desc  $fe80
        DEFINE  ramt  $fd50
      ELSE
        DEFINE  desc  $fc21
        DEFINE  ramt  desc
      ENDIF
        output  loader.bin
        org     $5b00+ini-prnbuf
ini     ld      de, desc
        di
        db      $de, $c0, $37, $0e, $8f, $39, $96 ;OVER USR 7 ($5ccb)
        ld      hl, $5ccb+descom-ini
        ld      bc, $7f
        ldir
      IF  border_loading=0
        xor     a
      ELSE
        ld      a, border_loading
      ENDIF
        out     ($fe), a
        ld      hl, $5ccb+descom-ini-1
        ld      de, $5aff
        call    desc
        ld      hl, $5ccb+prnbuf-ini
        ld      d, $5b
        push    de
        ld      c, fin-prnbuf
        ldir
        ret
prnbuf  ld      hl, $8000-maplen
        ld      de, engcomp_size
        push    hl
        call    $07f4
        di
      IF  smooth=0
      ELSE
        pop     hl
        ld      de, ramt-maplen
        ld      bc, maplen
        ldir
        ld      hl, $8000-maplen+engcomp_size-1
        ld      de, ramt-1-maplen
        call    desc
        ld      de, $ffff
        ld      hl, ramt-1-maplen-codel2-codel1-codel0-bl3len
        ld      bc, $360
        lddr
        push    hl
        ld      a, $17
        ld      bc, $7ffd
        out     (c), a
        ld      ($ffff), a
        ld      a, $10
        out     (c), a
        ld      a, ($ffff)
        cp      $17
        ld      de, ramt-1-maplen
        jr      z, next
        ld      hl, ramt-1-maplen-codel2
        ld      bc, codel1
        lddr
        ld      hl, init1
        ld      ($fffd), hl
        ld      hl, frame1
        ld      ($fff2), hl
        jr      copied
next    call    ramt-maplen-12
        jr      z, copied
        ld      hl, ramt-1-maplen-codel2-codel1
        ld      bc, codel0
        lddr
        ld      hl, init0
        ld      ($fffd), hl
        ld      hl, frame0
        ld      ($fff2), hl
copied  pop     hl
        ld      de, $7fff
        ld      bc, $2469
        lddr
        ld      hl, $8000+maincomp_size-1
        ld      de, $8040+main_size-1
        call    desc
        ld      hl, $8040
        ld      de, $8000
        push    de
        ld      bc, main_size
        ldir
        ret
      ENDIF
fin
screen  incbin  loading.zx7
descom  
      IF  smooth=0
        incbin  dzx7b_rcs_0.bin
      ELSE
        incbin  dzx7b_rcs_1.bin
      ENDIF
