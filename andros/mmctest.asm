        output "mmctest.bin"
;---------------------------------------------------------------------------------------------
;
; ZXMMC+ test software; allows reading/writing blocks to/from the screen and restoring
; 16K snapshots in ZX-Badaloc's BOOTROM firmware format.
;
; Unica modifica rispetto a zxmmc: la copia dei 512K avviene ad inizio card.
;
; MMC routines are from ZX-Badaloc BOOTROM Version 4.96 01/03/2007, that could run at 21MHz.
; NEW VERSION with OUTI/INI instruction unrolling, suggested by Paolo Ferraris, for maximum
; performance (218Kbytes/sec @3.5MHz)
;
; 4 Functions are provided:
;
; 40.000:       CARD INIT. Returns number of found cards (0, 1 or 2)
; 40.003:       13 blocks (512 bytes each) at offset +512KB are written to the card (from screen content)
; 40.006:       13 blocks (512 bytes each) from offset +512KB are read from the card to the screen
;
;---------------------------------------------------------------------------------------------
;


SPI_PORT        equ     $3F
OUT_PORT        equ     $1F     ; port for CS control (D1:D0)
MMC_0           equ     $F6     ; D0 LOW = SLOT0 active; D3 low = NMI disabled
IDLE_STATE      equ     $40
OP_COND         equ     $41
READ_SINGLE     equ     $51
READ_MULTIPLE   equ     $52
TERMINATE_MULTI equ     $4C
WRITE_SINGLE    equ     $58
BLOCKSIZE       equ     $200    ; SD/MMC block size (bytes)
FATSIZE         equ     8       ; dimensioni FAT in termini di blocchi da 64KBytes (in pratica e` l'offset
                                ; da caricare nella word MSB dell'indirizzo della SD per accedere al primo
                                ; cluster di dati, subito oltre la FAT). 8 = 512KBytes (8192 entries da 64 bytes)

        org     40000

readcard
        di
        ld      c, SPI_PORT
        ld      hl, FATSIZE     ; MSB = FATSIZE = reads from a 512Kbytes offset
        ld      de, 0
        ld      ix, $5800
        ld      b, 5
        call    readata
        ld      b, 0
        ld      c, a
        ei
        ret

;-----------------------------------------------------------------------------------------
; READ DATA TEST subroutine
;
; HL, DE= MSB, LSB of 32bit address in MMC memory
; IX    = ram buffer address
;
; RETURN code
; Z OK, NZ ERROR

; DESTROYS AF, B
;-----------------------------------------------------------------------------------------
reinit  call    mmcinit
        ret     nz
readata ld      a, READ_SINGLE  ; Command code for multiple block read
        call    cs_low          ; set cs high
        out     (c), a
        nop
        out     (c), h
        nop
        out     (c), l
        nop
        out     (c), d
        nop
        out     (c), e
        nop
        out     (c), e
        call    waitr           ; waits for the MMC to reply != $FF
        dec     a
        jr      nz, reinit
        push    ix
        pop     hl              ; INI usa HL come puntatore
jrhere  call    waittok
        ret     nz
        ld      b, a
        inir
        inir
        ret

;
;-----------------------------------------------------------------------------------------
; MMC SPI MODE initialization. RETURNS ERROR CODE IN A register:
;
; 0 = OK
; 1 = Card RESET ERROR
; 2 = Card INIT ERROR
;
; Destroys AF, B.
;-----------------------------------------------------------------------------------------
mmcinit push    hl
        ld      hl, $FF00 + IDLE_STATE
        call    cs_high         ; set cs high
        ld      b, 9            ; sends 80 clocks
l_init  out     (c), h
        djnz    l_init
        call    cs_low          ; set cs low
        out     (c), l          ; sends the command
        ld      b, 4
        ld      hl, $9540       ; $40= 64
        xor     a
lsen0   out     (c), a          ; then sends four "00" bytes (parameters = NULL)
        djnz    lsen0
        out     (c), h          ; then this byte is ignored.
        call    waitr
        cp      $02             ; MMC should respond 01 to this command
        jr      nz, mmcfin      ; fail to reset
resetok call    cs_high         ; set cs high
        out     (c), h          ; 8 extra clock cycles
        call    cs_low          ; set cs low
        ld      a, OP_COND      ; Sends OP_COND command
        out     (c), a          ; sends the command
        xor     a
        out     (c), a          ; then sends four "00" bytes (parameters = NULL)
        out     (c), a
        out     (c), a
        out     (c), a
        out     (c), a          ; then this byte is ignored.
        call    waitr           ; waitr tries to receive a response reading an SPI
        bit     0, a            ; D0 SET = initialization still in progress...
        jr      z, ninitok
        call    cs_high         ; set cs high
loop3   djnz    loop3
        dec     h
        jr      nz, loop3
        pop     hl
        ret
ninitok djnz    resetok         ; if no response, tries to send the entire block 254 more times
        dec     l
        jr      nz, resetok
        inc     l
mmcfin  pop     hl
cs_high push    af
        ld      a, $ff
cs_hig1 out     (OUT_PORT), a
        pop     af
        ret

cs_low  push    af
        ld      a, MMC_0
        jr      cs_hig1
        
waittok push    bc
        ld      b, 10                         ; retry counter
waitl   call    waitr
        inc     a               ; waits for the MMC to reply $FE (DATA TOKEN)
        jr      z, exitw
        dec     a               ; but if not $FF, exits immediately (error code from MMC)
        jr      nz, exitw
        djnz    waitl
        inc     a               ; return A+2, NZ 
exitw   pop     bc
        ret

waitr   push    bc
        ld      c, 50           ; retry counter
resp    in      a, (SPI_PORT)   ; reads a byte from MMC
        inc     a               ; $FF = no card data line activity
        jr      nz, resp_ok
        djnz    resp
        dec     c
        jr      nz, resp
resp_ok pop     bc
        ret

; suponer 512 bytes por sector
;0b-   200      512 bytes por sector
;0d-     4      4 sectores por cluster
;0e-  184e      6222 sectores reservados
;10-     2      2 copias FAT
;1e-     1      1 sector oculto
;24-  03d9      sectores por FAT  
;2c-     2      direccion cluster de la raiz

;03d9*200= 07b200 bytes por fat
;184e*200= 309C00 direccion fat1
;309C00+07b200= 384E00 direccion fat1
;384E00+07b200= 400000 direccion datos

;A5000,7AD800= 852800,1000000
;
; 384e00

/*<?php require 'zx.inc.php';
  $bas= line(10,"\xef\x22\x22\xaf").
        line(20,"\xf5\xc0" . number('40000'));
  $asm= assemble('mmctest');
  file_put_contents('mmc.tap',
      head_basic('mmctest', strlen($bas), 10).
      data($bas).
      head_code('mmctest', strlen($asm), 40000).
      data($asm));?>*/

