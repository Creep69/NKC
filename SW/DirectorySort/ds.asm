;*******************************
; Directory-sort for Jados
; (C) 1995 by Andreas Voggeneder
;*******************************
org $400
start:
      jsr @clrscreen
      moveq #53,d7
      trap #6
      move d0,d4
      moveq #52,d7
      trap #6
      tst d4
      beq.s m4                * Wenn Ramdisk keine Dichte hinzufuegen
      or.b #$20,d4

m4:
      lea drive(pc),a0
      move d4,(a0)
      moveq #1,d1             * Lesebefehl
      bsr flop

      lea text1(pc),a0
      moveq #7,d7
      trap #6
m3:
      jsr @ci
      cmp.b #'1',d0
      bne.s m1
      moveq #2,d4
      moveq #9,d3
      bra.s clean
m1:
      cmp.b #'2',d0
      bne.s m2
      moveq #12,d4
      moveq #4,d3
      bra.s clean
m2:
      cmp.b #'3',d0
      bne.s m3
      moveq #26,d4
      moveq #3,d3

clean:
      lea buffer(pc),a0

search_del:
      cmp #$e5e5,(a0)
      beq.s sort1
      cmp #$ffff,(a0)
      beq.s weiter1
      lea 32(a0),a0
      bra.s search_del

weiter1:
      movea.l a0,a1
      search_gu:
      cmp #$e5e5,(a0)
      beq.s sort1
      tst.w (a0)
      beq.s move
      lea 32(a0),a0
      bra.s search_gu

move:                   * A1=Zieladresse A0=Quelladresse
      moveq #15,d6
move1:
      move (a0)+,(a1)+
      dbra d6,move1
      move #$ffff,-32(a0)
      bra.s search_gu

Sort1:
      move #$e5e5,(a1)
sort:

      lea buffer(pc),a0
      clr.l d7                * Vertauschungsflagg =0

compare1:
      clr.l d6                * Zûhler=0
      cmp #$e5e5,32(a0)
      beq end                 * Durchgang beendet
      adda.l d4,a0            * Auf ersten Eintrag positionieren

compare:
      addq.b #1,d6
      cmp.b d3,d6
      bne.s weiter
      subq.b #1,d6             * Beide Eintrûge gleich, auf nûchsten positionieren
      bra.s next

weiter:
      move.b (a0)+,d0
      cmp.b 31(a0),d0        * mit naechstem Eintrag vergleichen
      beq.s compare           * wenn gleich, dann naechstes Zeichen
      bhi.s swap
      next:
      moveq #32,d0
      sub d6,d0
      sub d4,d0
      adda.l d0,a0            * Nûchster Eintrag
      bra.s compare1

swap:                   * Vertauschung durchfýhren
      lea swap_buf(pc),a1
      suba.l d6,a0
      suba.l d4,a0
      moveq.l #15,d6          * 16 Worte pro Eintrag
      swap1:
      move (a0)+,(a1)+
      dbra d6,swap1
      moveq #15,d6
swap2:
      move (a0),-32(a0)         * 2. auf 1.Eintrag kopieren
      addq.l #2,a0
      dbra d6,swap2
      moveq #15,d6
      lea swap_buf(pc),a1
      lea -32(a0),a0
swap3:
      move (a1)+,(a0)+
      dbra d6,swap3
      moveq #$ff,d7           * Vertauschungsflagg <>0 setzen
      lea -32(a0),a0
      bra.s compare1

end:
      tst.b d7                * Vertauschungsflagg <>0 -> noch mal
      bne sort
      moveq #2,d1             * Schreibbefehl

flop:
      lea buffer(pc),a0
      move #2,d2              * Sektor 2
      move drive(pc),d4       * Aktuelles Laufwerk
      bne.s m5
      clr d3                  * wenn Ramdisk dann Spur 0
      bra.s m6
m5:
      move #3,d3              * Spur 3
m6:
      move #$3,d5             * 4 Sektoren
      schleife:
      movem d0-d5,-(a7)
      moveq #51,d7            * Floppy (Jados)
      trap #6
      movem (a7)+,d0-d5
      adda #$400,a0
      addq #1,d2
      dbra d5,schleife        * Alle Sektoren lesen
      rts

text1: dc.b 'Sortieren nach: 1= Name',$d,$a
       dc.b '                2= Extension',$d,$a
       dc.b '                3= Laenge',$d,$a,0
ds 0
drive: ds.w 1
swap_buf: ds.b 32
buffer:
end
