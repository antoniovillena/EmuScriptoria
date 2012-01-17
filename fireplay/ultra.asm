
      IFDEF enram
        DEFB    PAD, PAD, PAD; 3 bytes
      ELSE
L34BC:  JP      L3603
      ENDIF

L34BF:  INC     H               ;4
      IFDEF sinborde
        EX      AF,AF'          ;4
        JR      NC,L34CC        ;7/12   41/43
        XOR     B               ;4
        LD      (DE),A          ;7
        INC     DE              ;6
        LD      A,$04           ;7
        EX      AF,AF'          ;4
        IN      L,(C)           ;12
        JP      (HL)            ;4
L34CC:  XOR     B               ;4
        ADD     A,A             ;4
        RET     C               ;5
        ADD     A,A             ;4
        EX      AF,AF'          ;4
        IN      L,(C)           ;12
        JP      (HL)            ;4
        DEFB    PAD, PAD, PAD; 3 bytes
      ELSE
        JR      NC,L34CD        ;7/12     46/48
        XOR     B               ;4
        XOR     $9C             ;7
        LD      (DE),A          ;7
        INC     DE              ;6
        LD      A,$DC           ;7
        EX      AF,AF'          ;4
        IN      L,(C)           ;12
        JP      (HL)            ;4
L34CD:  XOR     B               ;4
        ADD     A,A             ;4
        RET     C               ;5
        ADD     A,A             ;4
        EX      AF,AF'          ;4
        OUT     ($FE),A         ;11
        IN      L,(C)           ;12
        JP      (HL)            ;4
      ENDIF

    IFDEF enram
L34D7:  POP     HL              ; 56 bytes
        LD      SP,HL
        POP     HL              ; reemplazo pila, 4 bytes
        LD      ($BFFE),HL
        POP     HL
        JP      L3808           ;SNAP48-2
        DEFB    PAD, PAD, PAD, PAD, PAD, PAD, PAD, PAD; 14 bytes
        DEFB    PAD, PAD, PAD, PAD, PAD, PAD;
    ELSE
;SNA128
L34D7:  DEC     BC
        EXX
        LD      A,E
        CP      $18
        JP      Z,L3502         ;SNA48
        AND     A
        EXX
        OUT     (C),A
        EXX
        DEC     SP
        DEC     SP
        INC     E
        EXX
        LD      D,$C0
      IFDEF sinborde
        LD      B,$00
      ELSE
        LD      B,$EF
      ENDIF
        JP      L3B08
    ENDIF

;GET16
L34EF:  LD      B,0             ; 10 bytes
        CALL    L05ED           ; esta rutina lee 2 pulsos e inicializa el contador de pulsos
        CALL    L05ED
        LD      A,B
        CP      12
        ADC     HL,HL
        JR      NC,L34EF
        RET

L34FF:  IN      L,(C)
        JP      (HL)

;SNA48
      IFDEF enram
L3502:  XOR     A
        JP      L3C06
        DEFB    PAD, PAD, PAD, PAD, PAD, PAD, PAD; 7 bytes
      ELSE
L3502:  POP     HL              ; 56 bytes
        LD      SP,HL
        POP     HL              ; reemplazo pila, 4 bytes
        LD      ($BFFE),HL
        POP     HL
        JP      L3802           ;SNAP48-2
        DEFB    PAD; 1 byte
      ENDIF

      IFDEF sinborde
        DEFB    PAD; 1 byte
        DEFB    $00, $00, $FF   ; 0D
        DEFB    $00, $00, $FF   ; 10
        DEFB    $00, $00, $FF   ; 13
        DEFB    $00, $00, $FF   ; 16
        DEFB    $00, $00, $FF   ; 19
        DEFB    $00, $00, $FF   ; 1C
        DEFB    $00, $00, $FF   ; 1F
        DEFB    $00, $00, $FF   ; 22
        DEFB    $00, $00, $FF   ; 25
        DEFB    $01, $01, $FF   ; 28
        DEFB    $01, $01, $FF   ; 2B
        DEFB    $01, $01, $FF   ; 2E
        DEFB    $01, $01, $FF   ; 31
        DEFB    $01, $01, $FF   ; 34
        DEFB    $01, $01, $FF   ; 37
        DEFB    $01, $01, $FF   ; 3A
        DEFB    $01, $01, $FF   ; 3D
        DEFB    $01, $01, $FF   ; 40
        DEFB    $01, $02, $FF   ; 43 --
        DEFB    $02, $02, $FF   ; 46 --
        DEFB    $02, $02, $FF   ; 49
        DEFB    $02, $02, $FF   ; 4C
        DEFB    $02, $02, $FF   ; 4F
        DEFB    $02, $02, $FF   ; 52
        DEFB    $02, $02, $FF   ; 55
        DEFB    $02, $02, $FF   ; 58
        DEFB    $02, $02, $FF   ; 5B
        DEFB    $02, $03, $FF   ; 5E
        DEFB    $02, $03, $FF   ; 61
        DEFB    $03, $03, $FF   ; 64
        DEFB    $03, $03, $FF   ; 67
        DEFB    $03, $03, $FF   ; 6A
        DEFB    $03, $03, $FF   ; 6D
        DEFB    $03, $03, $FF   ; 70
        DEFB    $03, $03, $FF   ; 73
        DEFB    $03, $03, $FF   ; 76
        DEFB    $03, $FF, $FF   ; 79
        DEFB    $03, $FF, $FF   ; 7C
        DEFB    $03             ; 7F
        DEFB    $00, $00, $FF   ; 80
        DEFB    $00, $00, $FF   ; 83
        DEFB    $00, $00, $FF   ; 86
        DEFB    $00, $00, $FF   ; 89
        DEFB    $00, $00, $FF   ; 8C
        DEFB    $01, $01, $FF   ; 8F
        DEFB    $01, $01, $FF   ; 92
        DEFB    $01, $01, $FF   ; 95
        DEFB    $01, $01, $FF   ; 98
        DEFB    $01, $02, $FF   ; 9B --
        DEFB    $02, $02, $FF   ; 9E
        DEFB    $02, $02, $FF   ; A1
        DEFB    $02, $02, $FF   ; A4
        DEFB    $02, $02, $FF   ; A7
        DEFB    $02, $03, $FF   ; AA
        DEFB    $03, $03, $FF   ; AD
        DEFB    $03, $03, $FF   ; B0
        DEFB    $03, $03, $FF   ; B3
        DEFB    $03, $03, $FF   ; B6
        DEFB    $03, $FF, $FF   ; B9
        DEFB    $FF, $FF        ; BC
      ELSE
        DEFB    $EC, $EC, $7F   ; 0D
        DEFB    $EC, $EC, $7F   ; 10
        DEFB    $EC, $EC, $7F   ; 13
        DEFB    $EC, $EC, $7F   ; 16
        DEFB    $EC, $EC, $7F   ; 19
        DEFB    $EC, $EC, $7F   ; 1C
        DEFB    $EC, $EC, $7F   ; 1F
        DEFB    $EC, $EC, $7F   ; 22
        DEFB    $EC, $EC, $7F   ; 25
        DEFB    $ED, $ED, $7F   ; 28
        DEFB    $ED, $ED, $7F   ; 2B
        DEFB    $ED, $ED, $7F   ; 2E
        DEFB    $ED, $ED, $7F   ; 31
        DEFB    $ED, $ED, $7F   ; 34
        DEFB    $ED, $ED, $7F   ; 37
        DEFB    $ED, $ED, $7F   ; 3A
        DEFB    $ED, $ED, $7F   ; 3D
        DEFB    $ED, $ED, $7F   ; 40
        DEFB    $ED, $EE, $7F   ; 43 --
        DEFB    $EE, $EE, $7F   ; 46 --
        DEFB    $EE, $EE, $7F   ; 49
        DEFB    $EE, $EE, $7F   ; 4C
        DEFB    $EE, $EE, $7F   ; 4F
        DEFB    $EE, $EE, $7F   ; 52
        DEFB    $EE, $EE, $7F   ; 55
        DEFB    $EE, $EE, $7F   ; 58
        DEFB    $EE, $EE, $7F   ; 5B
        DEFB    $EE, $EF, $7F   ; 5E
        DEFB    $EE, $EF, $7F   ; 61
        DEFB    $EF, $EF, $7F   ; 64
        DEFB    $EF, $EF, $7F   ; 67
        DEFB    $EF, $EF, $7F   ; 6A
        DEFB    $EF, $EF, $7F   ; 6D
        DEFB    $EF, $EF, $7F   ; 70
        DEFB    $EF, $EF, $7F   ; 73
        DEFB    $EF, $EF, $7F   ; 76
        DEFB    $EF, $7F, $7F   ; 79
        DEFB    $EF, $7F, $7F   ; 7C
        DEFB    $EF             ; 7F
        DEFB    $EC, $EC, $7F   ; 80
        DEFB    $EC, $EC, $7F   ; 83
        DEFB    $EC, $EC, $7F   ; 86
        DEFB    $EC, $EC, $7F   ; 89
        DEFB    $EC, $EC, $7F   ; 8C
        DEFB    $ED, $ED, $7F   ; 8F
        DEFB    $ED, $ED, $7F   ; 92
        DEFB    $ED, $ED, $7F   ; 95
        DEFB    $ED, $ED, $7F   ; 98
        DEFB    $ED, $EE, $7F   ; 9B --
        DEFB    $EE, $EE, $7F   ; 9E
        DEFB    $EE, $EE, $7F   ; A1
        DEFB    $EE, $EE, $7F   ; A4
        DEFB    $EE, $EE, $7F   ; A7
        DEFB    $EE, $EF, $7F   ; AA
        DEFB    $EF, $EF, $7F   ; AD
        DEFB    $EF, $EF, $7F   ; B0
        DEFB    $EF, $EF, $7F   ; B3
        DEFB    $EF, $EF, $7F   ; B6
        DEFB    $EF, $7F, $7F   ; B9
        DEFB    $7F, $7F, $7F   ; BC
      ENDIF

L35BF:  IN      L,(C)
        JP      (HL)

;; EXO_GETBITS
L35C2:  LD      BC,0            ; get D bits in BC
L35C5:  DEC     D
        RET     M
        CALL    L3B02           ; EXO_GETBIT
        RL      C
        RL      B
        JR      L35C5

; Tabla
L35D0:  DEFB    $ED, $DE, $D2, $C3, $00, $71, $62, $53;
        DEFB    $F1, $E5, $D6, $C7, $04, $78, $69, $5D;

;; EXO_GETPAIR
L35E0:  LD      IYL,C
        LD      D,(IY+0)
        CALL    L35C2           ; EXO_GETBITS
        PUSH    HL
        LD      L,(IY+52)
        LD      H,(IY+104)
        ADD     HL,BC           ; always clear C flag
        LD      B,H
        LD      C,L
        POP     HL
        RET

L35F4:  DEFB    PAD, PAD, PAD, PAD, PAD, PAD, PAD, PAD; 11 bytes
        DEFB    PAD, PAD, PAD;

L35FF:  LD      A,R             ;9        49 (41 sin borde)
        LD      L,A             ;4
        LD      B,(HL)          ;7
L3603:  LD      A,IXL           ;8
        LD      R,A             ;9
      IFDEF sinborde
        DEC     H               ;4
        IN      L,(C)           ;12
        JP      (HL)            ;4
        DEFB    PAD, PAD; 2 bytes
      ELSE
        LD      A,B             ;4
        EX      AF,AF'          ;4
        DEC     H               ;4
        IN      L,(C)           ;12
        JP      (HL)            ;4
      ENDIF

L360D:  PUSH    IX              ; 133 bytes
        POP     BC              ; pongo la direccion de comienzo en BC
        EXX                     ; salvo DE, en caso de volver al cargador estandar y para hacer luego el checksum
        LD      C,$00
        DEFB    $2A
L3614:  JR      NZ,L3628        ; return if at any time space is pressed.
L3616:  LD      B,0
        CALL    L05ED           ; leo la duracion de un pulso (positivo o negativo)
        JR      NC,L3614        ; si el pulso es muy largo retorno a bucle
        LD      A, B
        CP      40              ; si el contador esta entre 24 y 40
        JR      NC,L362C        ; y se reciben 8 pulsos (me falta inicializar HL a 00FF)
        CP      24
        RL      L
        JR      NZ,L362C
L3628:  EXX
        LD      C,2
        RET
L362C:  CP      16              ; si el contador esta entre 10 y 16 es el tono guia
        RR      H               ; de las ultracargas, si los ultimos 8 pulsos
        CP      10              ; son de tono guia H debe valer FF
        JR      NC,L3616
        INC     H
        JR      NZ,L3616        ; si detecto sincronismo sin 8 pulsos de tono guia retorno a bucle
        CALL    L05ED           ; leo pulso negativo de sincronismo
        LD      L,$01           ; HL vale 0001, marker para leer 16 bits en HL (checksum y byte flag)
        CALL    L34EF           ; leo 16 bits, ahora temporizo cada 2 pulsos
        POP     AF              ; machaco la direccion de retorno de la carga estandar
        EX      AF,AF'          ; A es el byte flag que espero
        CP      L               ; lo comparo con el que me encuentro en la ultracarga
        RET     NZ              ; salgo si no coinciden
        XOR     H               ; xoreo el checksum con en byte flag, resultado en A
        EXX                     ; guardo checksum por duplicado en H' y L'
        PUSH    BC              ; pongo direccion de comienzo en pila
        LD      H,A
        LD      L,A
        EXX
        LD      HL,$0020        ; leo 11 bits en HL
        LD      D,A
        LD      E,$FE
        CALL    L34EF
        SRL     H
        PUSH    HL
        LD      H,$35+OFFS
        POP     IX
        JR      NC, L3661
        RES     5, L
        XOR     A
        LD      A,(HL)
        LD      IXL,A

    IFDEF sinborde
L3661:  LD      A,$01           ; A' tiene que valer esto para entrar en Raudo
        EX      AF,AF'
        AND     IXH
        JR      NZ,L366C
        LD      SP,$C000
        DEFB    $FE
L366C:  POP     DE              ; recupero en DE la direccion de comienzo del bloque
        INC     C               ; pongo en flag Z el signo del pulso
        LD      BC,$00FE        ; este valor es el que necesita B para entrar en Raudo
        JR      Z,L367F
        LD      H,$37+OFFS
L366A:  IN      F,(C)
        JP      PE,L366A
        CALL    L37C3           ; salto a Raudo segun el signo del pulso en flag Z
        JR      L3687
L367F:  IN      F,(C)
        JP      PO,L367F
        CALL    L3603           ; salto a Raudo
L3687:  AND     IXH             ; en caso de no verificar checksum me salto la rutina
        EXX                     ; ya se ha acabado la ultracarga (Raudo)
        JR      Z,L3696
L368C:  LD      A,(BC)          ; verifico checksum
        XOR     H
        LD      H,A
        INC     BC
        DEC     DE
        LD      A,D
        OR      E
        JR      NZ,L368C
        XOR     H               ; salgo con A=0 H=0 L=checksum y Carry activo si todo
L3696:  PUSH    BC              ; ha ido bien
        POP     IX              ; IX debe apuntar al siguiente byte despues del bloque
        RET     NZ              ; si no coincide el checksum salgo con Carry desactivado
        SCF
        RET
    ELSE
L3661:  LD      A,$D8           ; A' tiene que valer esto para entrar en Raudo
        EX      AF,AF'
        AND     IXH
        JR      NZ,L366C
        LD      SP,$C000
        DEFB    $FE
L366C:  POP     DE              ; recupero en DE la direccion de comienzo del bloque
        INC     C               ; pongo en flag Z el signo del pulso
        LD      BC,$EFFE        ; este valor es el que necesita B para entrar en Raudo
        JR      Z,L367F
        LD      H,$37+OFFS
L3675:  IN      F,(C)
        JP      PE,L3675
        CALL    L37C3           ; salto a Raudo segun el signo del pulso en flag Z
        JR      L3687
L367F:  IN      F,(C)
        JP      PO,L367F
        CALL    L3603           ; salto a Raudo
L3687:  AND     IXH             ; en caso de no verificar checksum me salto la rutina
        EXX                     ; ya se ha acabado la ultracarga (Raudo)
        JR      Z,L3696
L368C:  LD      A,(BC)          ; verifico checksum
        XOR     H
        LD      H,A
        INC     BC
        DEC     DE
        LD      A,D
        OR      E
        JR      NZ,L368C
        XOR     H               ; salgo con A=0 H=0 L=checksum y Carry activo si todo
L3696:  PUSH    BC              ; ha ido bien
        POP     IX              ; IX debe apuntar al siguiente byte despues del bloque
      IFDEF enram
        JP      L3C05
      ELSE
        RET     NZ              ; si no coincide el checksum salgo con Carry desactivado
        SCF
        RET
      ENDIF
    ENDIF

;EXO-A
L369C:  LD      IY,$5B00        ; EXO_MAPBASEBITS
        LD      A,128
        LD      B,52
        PUSH    DE
;; EXO_INITBITS
L36A5:  EX      AF,AF'
        LD      A,B
        SUB     4
        AND     15
        JR      NZ,L36B0
        LD      DE,1            ; DE=b2
L36B0:  LD      C,16
        EX      AF,AF'
L36B3:  CALL    L3B02           ; EXO_GETBIT
        RL      C
        JR      NC,L36B3
        LD      (IY+0),C        ; bits[i]=b1
        JR      L36C2           ;EXO-B

L36BF:  IN      L,(C)
        JP      (HL)

;EXO-B
L36C2:  PUSH    HL
        LD      HL,1
        DEFB    $D2             ; 3 bytes nop (JP NC)
L36C7:  ADD     HL,HL
        DEC     C
        JR      NZ,L36C7
        LD      (IY+52),E
        LD      (IY+104),D      ; base[i]=b2
        ADD     HL,DE
        EX      DE,HL
        INC     IY
        POP     HL
        DEC     B               ; EXO_INITBITS
        JP      NZ,L36A5
        POP     DE
;; EXO_LITERALCOPY
L36DB:  LDI
;; EXO_MAINLOOP
L36DD:  CALL    L3B02           ; EXO_GETBIT, literal?
        JR      C,L36DB         ; EXO_LITERALCOPY
        LD      C,255
L36E4:  INC     C
        CALL    L3B02           ; EXO_GETBIT
        JR      NC,L36E4
        BIT     4,C
        RET     NZ
        PUSH    DE
        CALL    L35E0           ; EXO_GETPAIR
        PUSH    BC
        JP      L37D2           ;EXO-C

      IFDEF sinborde
L36F5:  XOR     B
        ADD     A,A
        RET     C
        ADD     A,A
        EX      AF,AF'
        IN      L,(C)
        JP      (HL)
        DEFB    PAD, PAD; 2 bytes
L36FF:  INC     H
        EX      AF,AF'          ;4
        JR      NC,L36F5
        XOR     B
        LD      (DE),A
        INC     DE
        LD      A,$04
        EX      AF,AF'
        IN      L,(C)           ;12
        JP      (HL)            ;4
        DEFB    PAD; 1 byte
        DEFB    PAD; 1 byte
        DEFB    $00, $00, $FF   ; 0D
        DEFB    $00, $00, $FF   ; 10
        DEFB    $00, $00, $FF   ; 13
        DEFB    $00, $00, $FF   ; 16
        DEFB    $00, $00, $FF   ; 19
        DEFB    $00, $00, $FF   ; 1C
        DEFB    $00, $00, $FF   ; 1F
        DEFB    $00, $00, $FF   ; 22
        DEFB    $00, $00, $FF   ; 25
        DEFB    $01, $01, $FF   ; 28
        DEFB    $01, $01, $FF   ; 2B
        DEFB    $01, $01, $FF   ; 2E
        DEFB    $01, $01, $FF   ; 31
        DEFB    $01, $01, $FF   ; 34
        DEFB    $01, $01, $FF   ; 37
        DEFB    $01, $01, $FF   ; 3A
        DEFB    $01, $01, $FF   ; 3D
        DEFB    $01, $01, $FF   ; 40
        DEFB    $01, $02, $FF   ; 43 --
        DEFB    $02, $02, $FF   ; 46 --
        DEFB    $02, $02, $FF   ; 49
        DEFB    $02, $02, $FF   ; 4C
        DEFB    $02, $02, $FF   ; 4F
        DEFB    $02, $02, $FF   ; 52
        DEFB    $02, $02, $FF   ; 55
        DEFB    $02, $02, $FF   ; 58
        DEFB    $02, $02, $FF   ; 5B
        DEFB    $02, $03, $FF   ; 5E
        DEFB    $02, $03, $FF   ; 61
        DEFB    $03, $03, $FF   ; 64
        DEFB    $03, $03, $FF   ; 67
        DEFB    $03, $03, $FF   ; 6A
        DEFB    $03, $03, $FF   ; 6D
        DEFB    $03, $03, $FF   ; 70
        DEFB    $03, $03, $FF   ; 73
        DEFB    $03, $03, $FF   ; 76
        DEFB    $03, $FF, $FF   ; 79
        DEFB    $03, $FF, $FF   ; 7C
        DEFB    $03             ; 7F
        DEFB    $00, $00, $FF   ; 80
        DEFB    $00, $00, $FF   ; 83
        DEFB    $00, $00, $FF   ; 86
        DEFB    $00, $00, $FF   ; 89
        DEFB    $00, $00, $FF   ; 8C
        DEFB    $01, $01, $FF   ; 8F
        DEFB    $01, $01, $FF   ; 92
        DEFB    $01, $01, $FF   ; 95
        DEFB    $01, $01, $FF   ; 98
        DEFB    $01, $02, $FF   ; 9B --
        DEFB    $02, $02, $FF   ; 9E
        DEFB    $02, $02, $FF   ; A1
        DEFB    $02, $02, $FF   ; A4
        DEFB    $02, $02, $FF   ; A7
        DEFB    $02, $03, $FF   ; AA
        DEFB    $03, $03, $FF   ; AD
        DEFB    $03, $03, $FF   ; B0
        DEFB    $03, $03, $FF   ; B3
        DEFB    $03, $03, $FF   ; B6
        DEFB    $03, $FF, $FF   ; B9
        DEFB    $FF, $FF        ; BC
      ELSE
L36F5:  XOR     B
        ADD     A,A
        RET     C
        ADD     A,A
        EX      AF,AF'
        OUT     ($FE),A         ;11
        IN      L,(C)
        JP      (HL)
L36FF:  INC     H
        JR      NC,L36F5
        XOR     B
        XOR     $9C
        LD      (DE),A
        INC     DE
        LD      A,$DC
        EX      AF,AF'
        IN      L,(C)           ;12
        JP      (HL)            ;4
        DEFB    $EC, $EC, $7F   ; 0D
        DEFB    $EC, $EC, $7F   ; 10
        DEFB    $EC, $EC, $7F   ; 13
        DEFB    $EC, $EC, $7F   ; 16
        DEFB    $EC, $EC, $7F   ; 19
        DEFB    $EC, $EC, $7F   ; 1C
        DEFB    $EC, $EC, $7F   ; 1F
        DEFB    $EC, $EC, $7F   ; 22
        DEFB    $EC, $EC, $7F   ; 25
        DEFB    $ED, $ED, $7F   ; 28
        DEFB    $ED, $ED, $7F   ; 2B
        DEFB    $ED, $ED, $7F   ; 2E
        DEFB    $ED, $ED, $7F   ; 31
        DEFB    $ED, $ED, $7F   ; 34
        DEFB    $ED, $ED, $7F   ; 37
        DEFB    $ED, $ED, $7F   ; 3A
        DEFB    $ED, $ED, $7F   ; 3D
        DEFB    $ED, $ED, $7F   ; 40
        DEFB    $ED, $EE, $7F   ; 43 --
        DEFB    $EE, $EE, $7F   ; 46 --
        DEFB    $EE, $EE, $7F   ; 49
        DEFB    $EE, $EE, $7F   ; 4C
        DEFB    $EE, $EE, $7F   ; 4F
        DEFB    $EE, $EE, $7F   ; 52
        DEFB    $EE, $EE, $7F   ; 55
        DEFB    $EE, $EE, $7F   ; 58
        DEFB    $EE, $EE, $7F   ; 5B
        DEFB    $EE, $EF, $7F   ; 5E
        DEFB    $EE, $EF, $7F   ; 61
        DEFB    $EF, $EF, $7F   ; 64
        DEFB    $EF, $EF, $7F   ; 67
        DEFB    $EF, $EF, $7F   ; 6A
        DEFB    $EF, $EF, $7F   ; 6D
        DEFB    $EF, $EF, $7F   ; 70
        DEFB    $EF, $EF, $7F   ; 73
        DEFB    $EF, $EF, $7F   ; 76
        DEFB    $EF, $7F, $7F   ; 79
        DEFB    $EF, $7F, $7F   ; 7C
        DEFB    $EF             ; 7F
        DEFB    $EC, $EC, $7F   ; 80
        DEFB    $EC, $EC, $7F   ; 83
        DEFB    $EC, $EC, $7F   ; 86
        DEFB    $EC, $EC, $7F   ; 89
        DEFB    $EC, $EC, $7F   ; 8C
        DEFB    $ED, $ED, $7F   ; 8F
        DEFB    $ED, $ED, $7F   ; 92
        DEFB    $ED, $ED, $7F   ; 95
        DEFB    $ED, $ED, $7F   ; 98
        DEFB    $ED, $EE, $7F   ; 9B --
        DEFB    $EE, $EE, $7F   ; 9E
        DEFB    $EE, $EE, $7F   ; A1
        DEFB    $EE, $EE, $7F   ; A4
        DEFB    $EE, $EE, $7F   ; A7
        DEFB    $EE, $EF, $7F   ; AA
        DEFB    $EF, $EF, $7F   ; AD
        DEFB    $EF, $EF, $7F   ; B0
        DEFB    $EF, $EF, $7F   ; B3
        DEFB    $EF, $EF, $7F   ; B6
        DEFB    $EF, $7F, $7F   ; B9
        DEFB    $7F, $7F, $7F   ; BC
      ENDIF

L37BF:  LD      A,R
        LD      L,A
        LD      B,(HL)
L37C3:  LD      A,IXL
        LD      R,A

      IFDEF sinborde
        DEC     H
        IN      L,(C)
        JP      (HL)
        DEFB    PAD, PAD; 2 bytes
      ELSE
        LD      A,B
        EX      AF,AF'
        DEC     H
        IN      L,(C)
        JP      (HL)
      ENDIF

        DEFB    PAD, PAD, PAD, PAD, PAD;  5 bytes

;EXO-C
L37D2:  POP     IX
        LD      DE,512+48       ; 1?
        INC     B
        DJNZ    L37DE
        DEC     C
        JR      Z,L37E5         ; EXO_GOFORIT
        DEC     C
L37DE:  LD      DE,1024+32
        JR      Z,L37E5         ; EXO_GOFORIT
        LD      E,16
;; EXO_GOFORIT
L37E5:  CALL    L35C2           ; EXO_GETBITS
        EX      AF,AF'
        LD      A,E
        ADD     A,C
        LD      C,A
        EX      AF,AF'
        CALL    L35E0           ; EXO_GETPAIR, BC=offset
        POP     DE              ; DE=destination
        PUSH    HL    
        LD      H,D
        LD      L,E
        SBC     HL,BC           ; HL=origin
        PUSH    IX
        POP     BC              ; BC=lenght
        LDIR
        POP     HL              ; keep HL, DE is updated
        JP      L36DD           ; EXO_MAINLOOP

L37FF:  IN      L,(C)
        JP      (HL)

;SNA48-2
      IFDEF enram
        DEFB    PAD, PAD, PAD, PAD, PAD, PAD; 6 bytes
L3808:  LD      ($C000),HL
      ELSE
L3802:  LD      ($C000),HL
        JR      C, L380C
        EXX
        DEC     SP
        POP     AF              ; last byte 7FFD
        OUT     (C),A
L380C:  
      ENDIF
        POP     BC              ; BC'
        POP     DE              ; DE'
        POP     HL              ; HL'
        EXX
        POP     AF              ; AF'
        EX      AF,AF'
        POP     BC              ; BC
        POP     DE              ; DE
        POP     HL              ; IR
        POP     IX              ; IX
        POP     IY              ; IY
        LD      A,L
        LD      I,A
        POP     AF              ; IM,IFF
        JR      NC,L3821
        IM      2
L3821:  JR      NZ,L3824
        EI
L3824:  PUSH    AF
        DEC     SP
        POP     AF
        RRA
        OUT     ($FE),A
        LD      A,H
        LD      HL,2
        ADD     HL,SP
        LD      R,A
        POP     AF              ; AF
        JP      (HL)

      IFDEF enram
        DEFB    PAD; 1 byte
      ENDIF
