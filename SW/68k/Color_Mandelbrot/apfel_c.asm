PMIn equ -2250
PMAX EQU 750
QMIN EQU -1500
QMAX EQU 1500
M EQU 16*1000*1000
ANZAHL EQU 100

CPU equ 2              ; 68000
color equ $ffffffa0*CPU

START:
         jsr @clr
         move #511,d1
xschleife:
         move #255,d2
yschleife:
         move.l #pmax-pmin,d3
         muls d1,d3
         lsr.l #8,d3
         lsr.l #1,d3
         add #pmin,d3
         move.l #qmax-qmin,d4
         muls d2,d4
         lsr.l #8,d4
         add #qmin,d4
         clr.l d5
         clr.l d6
         clr d7
         movem.l d1-d2,-(a7)
iterat:
         move d5,d1
         muls d1,d1
         move d6,d0
         muls d0,d0
         sub.l d0,d1
         divs #1000,d1
         add d3,d1
         move d5,d2
         muls d6,d2
         divs #500,d2
         add d4,d2
         move d1,d5
         move d2,d6
         addq #1,d7
         muls d1,d1
         muls d2,d2
         add.l d2,d1
         cmp.l #m,d1
         bge.s ausgabe
         cmp #anzahl,d7
         beq.s ausgabe
         bra.s iterat
ausgabe:
         movem.l (a7)+,d1-d2
         cmp #anzahl,d7
         beq.s weiter
         ;btst #0,d7
         ;beq.s weiter
         jsr @moveto
         move.b d7,color.w
         move.b #$80,d0
         jsr @cmd
weiter:
         dbra d2,yschleife
         dbra d1,xschleife
warte:
         jsr @ci
         rts

