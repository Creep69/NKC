*****************************************
*                 XDIR                  *
*            v1.0 20210615              *
*           (c) Jens Mewes              *
*****************************************

start:
 move #0, option
 move #0, optflag
 moveq #42, d7                          * GETPARM1
 trap #6
 tst.b (a0)                             * kein Parameter
 beq.s lp002
 cmp.b #'-', (a0)                       * Option?
 bne.s lp001
 addq.l #1, a0
lp010:
 move.b (a0)+, d0
 beq.s lp020
 cmp.b #'-', d0
 beq.s lp010
 cmp.b #'R', d0
 bne.s lp011
 move #-1, optflag
 bra.s lp010
lp011:
 cmp.b #'X', d0
 bne.s lp012
 move #4, option
 bra.s lp010
lp012:
 cmp.b #'T', d0
 bne.s lp013
 move #8, option
 bra.s lp010
lp013:
 cmp.b #'S', d0
 bne.s lp014
 move #12, option
 bra.s lp010
lp014:
 cmp.b #'H', d0
 bne.s lp015
 bra.s hilfe
lp015:
 bra.s lp010

lp020:
 moveq #43, d7                          * GETPARM2
 trap #6

lp001:
 cmp.b #':', 1(a0)                      * Laufwerksangabe?
 bne.s lp002
 move.b (a0), d0
 bra.s lp004
lp002:
 moveq #53, d7                          * GETDRIVE
 trap #6
 cmp.b #5, d0                           * HD?
 bge.s lp003
 add.b #'0', d0                         * Ramdisk und Floppy auf 0..4
 bra.s lp004
lp003:
 sub.b #5, d0
 add.b #'A', d0
lp004:
 move.b d0, lw
 move.b #':', lw+1
 movea.l a0, a1
 lea buffer(pc), a0
 move #11*1024, d1
 move.b #%00000111, d2
 moveq #1, d3
 move #74, d7                           * DIRECTORY
 trap #6
 bsr sort
 bsr ausgabe
 rts

hilfe:
 move #!clrscreen, d7
 trap #1
 lea hilftxt(pc), a0
 move (a0)+, d0
 bsr write
 move #!crlf, d7
 trap #1
 rts

vergleich:
 movem.l d2-d4/a1-a2, -(a7)
 move optflag, d2
vergl001:
 lea opttab(pc), a1
 adda option, a1
 movea.l (a1), a1
vergl002:
 move (a1)+, d3                         * Anzahl der Bytes
 beq.s vergl010                         * keine weiteren Bytes
 subq #1, d3                            * als Zûhler
 clr.l d4
 move (a1)+, d4
 movea.l a0, a2
 adda.l d4, a2
vergl003:
 move.b off1(a2), d0
 tst d2
 beq.s vergl004
 cmp.b (a2)+, d0
 beq.s vergl005
 bra.s vergl030
vergl004:
 cmp.b (a2)+, d0
 beq.b vergl005
 bra.s vergl020
vergl005:
 dbra d3, vergl003
 bra.s vergl002
vergl010:
 clr d0                                 * nicht grüþer
 movem.l (a7)+, d2-d4/a1-a2
 rts
vergl020:
 bhi.s vergl010
 moveq #-1, d0                          * grüþer
 movem.l (a7)+, d2-d4/a1-a2
 rts
vergl030:
 blo.s vergl010
 moveq #-1, d0                          * kleiner
 movem.l (a7)+, d2-d4/a1-a2
 rts

tausche:
 move.l a0, -(a7)
 move.l #off1, d3
 subq.l #1, d3
tau001:
 move.b (a0), d0
 move.b off1(a0), (a0)
 move.b d0, off1(a0)
 addq.l #1, a0
 dbra d3, tau001
 movea.l (a7)+, a0
 rts

sort:
 bsr genlist
 subq.l #1, d6
 beq.s sort010
sort001:
 lea buffer1(pc), a0
 clr.l d5                               * Vertauscht = falsch
 clr.l d4                               * 1..n-1
sort002:
 bsr vergleich
 tst d0
 beq.s sort003                          * nicht groesser
 bsr tausche
 moveq #-1, d5                          * Vertauscht = wahr
sort003:
 adda.l #off1, a0
 addq #1, d4                            * Anzahl erhühen
 cmp d6, d4                             * Ende erreicht?
 blt.s sort002                          * nein
 subq #1, d6
 ble.s sort010                          * Fertig
 tst d5
 beq.s sort010                          * Fertig
 bra.s sort001                          * sonst noch ein Durchlauf
sort010:
 rts

genlist:
 lea buffer(pc), a0
 movea.l a0, a3                         * Puffer sichern
 lea buffer1(pc), a1
 clr.l d6                               * Anzahl
 clr.l size
gl001:
 move.l #'    ', name(a1)
 move.l #'    ', name+4(a1)             * Name mit Space vorbelegen
 movea.l a1, a2
 adda.l #name, a2
gl002:
 move.b (a0)+, d0
 beq gl100                              * Ende
 cmp.b #$0d, d0
 beq.s gl100
 cmp.b #'.', d0                         * Name zu Ende?
 beq.s gl003
 move.b d0, (a2)+
 bra.s gl002
gl003:
 movea.l a1, a2
 adda.l #ext, a2
 moveq #3-1, d3
gl005:
 move.b (a0)+, (a2)+
 dbra d3, gl005
 move.b #' ', (a2)+
gl006:
 cmp.b #' ', (a0)+                      * Space raus
 beq.s gl006
 subq.l #1, a0
 movea.l a1, a2
 adda.l #len, a2
 bsr genlen
gl007:
 cmp.b #' ', (a0)+                      * Space raus
 beq.s gl007
 subq.l #1, a0
 movea.l a1, a2
 adda.l #date, a2
 bsr gendate
gl008:
 cmp.b #' ', (a0)+                      * Space raus
 beq.s gl008
 subq.l #1, a0
 movea.l a1, a2
 adda.l #mod, a2
 move.b (a0)+, (a2)+
 move.b (a0)+, (a2)+
 adda.l #offset, a3
 movea.l a3, a0
 adda.l #off1, a1                       * Buffer1 Offset
 addq.l #1, d6
 bra gl001
gl100:
 move d6, anz
 rts

genlen:
 clr.l d1
gln001:
 move.b (a0)+, d0
 cmp.b #' ', d0
 beq.s gln002
 sub.b #'0', d0
 mulu #10, d1
 add.b d0, d1
 bra.s gln001
gln002:
 asl.l #8, d1
 asl.l #2, d1                           * *1024
 move.l d1, (a2)
 add.l d1, size
 rts

gendate:
 move.b (a0)+, d0
 cmp.b #'F', d0
 bne.s gd001
 move.b #'0', d0
gd001:
 move.b d0, d1
 lsl.l #8, d1
 move.b (a0)+, d0
 cmp.b #'F', d0
 bne.s gd002
 move.b #'1', d0
gd002:
 move.b d0, d1
 lsl.l #8, d1
 addq.l #1, a0
 move.b (a0)+, d0
 cmp.b #'F', d0
 bne.s gd003
 move.b #'0', d0
gd003:
 move.b d0, d1
 lsl.l #8, d1
 move.b (a0)+, d0
 cmp.b #'F', d0
 bne.s gd004
 move.b #'1', d0
gd004:
 move.b d0, d1
 swap d1
 move.l d1, 4(a2)
 addq.l #1, a0
 clr.l d1
 move.b (a0)+, d0
 cmp.b #'F', d0
 bne.s gd005
 move.l #'1980', d1
 bra.s gd010
gd005:
 cmp.b #'5', d0
 blt.s gd006
 move.w #'19', d1
 bra.s gd007
gd006:
 move.w #'20', d1
gd007:
 swap d1
 move.b d0, d1
 lsl.w #8, d1
 move.b (a0)+, d1
gd010:
 move.l d1, (a2)
 rts

ausgabe:
 bsr kopf
 move #!crlf, d7
 trap #1
 move #!crlf, d7
 trap #1
 move anz, d6
 beq aus102
 lea buffer1(pc), a1
aus001:
 moveq #18, d3
aus002:
 movea.l a1, a0
 moveq #8, d0
 bsr write                              * Name
 lea space(pc), a0
 moveq #1, d0
 bsr write                              * ein Space
 movea.l a1, a0
 adda.l #ext, a0
 moveq #3, d0
 bsr write                              * Extension
 lea space(pc), a0
 moveq #5, d0
 bsr write                              * fýnf Spaces
 movea.l a1, a0
 adda.l #mod, a0
 moveq #2, d0
 bsr write                              * Modus
 bsr laenge
 bsr datum
 adda.l #off1, a1
 subq #1, d6
 beq.s aus100
 move #!crlf, d7
 trap #1
 dbra d3, aus002
 move #!crlf, d7
 trap #1
 lea nexttxt(pc), a0
 move (a0)+, d0
 bsr write
aus050:
 moveq #!csts, d7
 trap #1
 beq.s aus050
 move #!ci, d7
 trap #1
 cmp.b #$1b, d0                         * ESC
 beq.s aus100
 cmp.b #$03, d0                         * CTRL-C
 beq.s aus100
 bsr kopf
 lea forttxt(pc), a0
 move (a0)+, d0
 bsr write
 moveq #!crlf, d7
 trap #1
 moveq #!crlf, d7
 trap #1
 bra aus001
aus100:
 moveq #!crlf, d7
 trap #1
 moveq #!crlf, d7
 trap #1
 lea anztxt(pc), a0
 move (a0)+, d0
 bsr write
 move anz, d0
 lea buffer2(pc), a0
 move #!print4d, d7
 trap #1
 lea buffer2(pc), a0
 clr d0
ausg101:
 addq #1, d0
 tst.b (a0)+
 bne.s ausg101
 lea buffer2(pc), a0
 bsr write
 moveq #!crlf, d7
 trap #1
 lea groetxt(pc), a0
 move (a0)+, d0
 bsr write
 move.l size, d0
 bsr laeng
aus102:
 moveq #!crlf, d7
 trap #1
 rts

kopf:
 move #!clrscreen, d7
 trap #1
 lea kopftxt1(pc), a0
 move (a0)+, d0
 bsr write
 lea lw(pc), a0
 moveq #2, d0
 bsr write
kp01:
 rts

laenge:
 move.l len(a1), d0
laeng:                                  * weiterer Einsprung
 bsr print8d
 lea buffer2(pc), a0
 moveq #15, d0
 bsr write
 rts

datum:
 lea space(pc), a0
 moveq #4, d0
 bsr write
 movea.l a1, a0
 adda.l #date, a0
 addq.l #6, a0
 movea.l a0, a4
 moveq #2, d0
 bsr write                              * Tag
 lea punkt(pc), a0
 moveq #1, d0
 bsr write
 movea.l a4, a0
 subq.l #2, a0
 moveq #2, d0
 bsr write                              * Monat
 lea punkt(pc), a0
 moveq #1, d0
 bsr write
 movea.l a1, a0
 adda.l #date, a0
 moveq #4, d0
 bsr write                              * Jahr
 rts

write:
 movem.l d3/a0, -(a7)
 subq #1, d0
 bmi.s wr002
 move d0, d3
wr001:
 move.b (a0)+, d0
 move #!co2, d7
 trap #1
 dbra d3, wr001
wr002:
 movem.l (a7)+, d3/a0
 rts

print8d:
 movem.l d0-d7/a0-a6, -(a7)
 lea buffer2(pc), a0
 move #70, d7                           * PRINT8D
 trap #1
 lea buffer2(pc), a1
 move.l a1, d1
 adda.l #15, a1
 addq.l #1, a0
 move.b -(a0), -(a1)                    * die Endnull
 move #14-1, d3                         * 13 weitere Bytes
 clr d2
prt8d01:
 addq #1, d2
 subq #1, d3
 move.b -(a0), -(a1)
 cmpa.l d1, a0
 beq.b prt8d02
 cmp #3, d2
 bne.b prt8d01
 clr d2
 subq #1, d3
 move.b #'.', -(a1)
 bra.b prt8d01
prt8d02:
 move.b #' ', -(a1)
 dbra d3, prt8d02
 movem.l (a7)+, d0-d7/a0-a6
 rts


kopftxt1:       dc.w 21
                dc.b 'Inhalt des Laufwerks '
                ds 0
nexttxt:        dc.w 27
                dc.b 'weiter mit beliebiger Taste'
                ds 0
forttxt:        dc.w 14
                dc.b ' (Fortsetzung)'
                ds 0
anztxt:         dc.w 16
                dc.b 'Anzahl Dateien: '
                ds 0

groetxt:        dc.w 32
                dc.b 'Gesamtgrüþe der Dateien in Byte: '
                ds 0

hilftxt:        dc.w 660
                dc.b 'XDIR - Die erweiterte Directory-Funktion fýr JADOS'
                dc.b $0d, $0a, $0d, $0a
                dc.b 'Mit XDIR wird das Inhaltsverzeichnis eines JADOS-'
                dc.b 'Laufwerks sortiert ausgegeben.'
                dc.b $0d, $0a
                dc.b 'Die Ausgabe erfolgt Seitenweise. Eine Eingabe von '
                dc.b 'ESC oder CTRL-C bricht '
                dc.b $0d, $0a                   * 75
                dc.b 'die Ausgabe ab. Jede andere Eingabe listet weiter auf.'
                dc.b $0d, $0a                   * 56
                dc.b 'Ohne Angabe einer Option, wird nach Dateinamen sortiert.'
                dc.b $0d, $0a
                dc.b 'Es künnen wie gewohnt Laufwerk und Suchmuster angegeben'
                dc.b ' werden.'
                dc.b $0d, $0a, $0d, $0a
                dc.b 'Aufruf:     XDIR -Opt lw:*.*'
                dc.b $0d, $0a, $0d, $0a
                dc.b 'Optionen:   -X = Sortierung nach Dateierweiterung'
                dc.b $0d, $0a
                dc.b '            -T = Sortierung nach Datum'
                dc.b $0d, $0a
                dc.b '            -S = Sortierung nach Dateigrüþe'
                dc.b $0d, $0a
                dc.b '            -R = Umkehrung der Sortierreihenfolge'
                dc.b $0d, $0a
                dc.b '            -H = Diese Hilfe'
                dc.b $0d, $0a, $0d, $0a
                dc.b '2008 - Jens Mewes'
                dc.b $0d, $0a
                ds 0

space:          dc.b '                    '
                ds 0
punkt:          dc.b '....................'
                ds 0


opt01:          dc.w 8, name, 3, ext, 0
opt02:          dc.w 3, ext, 8, name, 0
opt03:          dc.w 8, date, 8, name, 3, ext, 0
opt04:          dc.w 4, len, 8, name, 3, ext, 0

opttab:
                dc.l opt01                      * Name, Extension
                dc.l opt02                      * -X: Extension, Name
                dc.l opt03                      * -T: Datum, Name, Extension
                dc.l opt04                      * -S: Grüsse, Name, Extension

buffer1:        ds.b 8
buffer:         ds.b 11*1024
buffer2:        ds.b 64

anz:            ds.w 1
size:           ds.l 1
lw:             ds.w 1
option:         ds.w 1
optflag:        ds.w 1

name    equ  0                          * 0..7
ext     equ  8                          * 8..11
mod     equ 12                          * 12..13
len     equ 14                          * 14..17
date    equ 18                          * 18..25

off1    equ 26

offset  equ 37

