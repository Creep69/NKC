* XtreePro fýr Jados
* (C) 1990-2021 by Andreas Voggeneder

* Cursortasten
rauf   equ $05
runter equ $18
links  equ $13
rechts equ $04

; Control-codes
ctrl_t equ $14  ; Tag all files
ctrl_u equ $15  ; Untag all files
ctrl_c equ $03  ; copy all tagged files
ctrl_k equ $0b  ; delete (kill) all tagged files
ctrl_r equ $12  ; Rename all tagged files

org $400
start:
      move #$87,d0
      moveq #!hardcopy,d7
      trap #1
      moveq #97,d7
      trap #1                         * Gruprog- Versionsnummer laden
      cmp #$600,d0
      blo f_vers
      moveq #24,d7
      trap #6                         * Jados-Vesion abfragen
      cmp.l #'3.02',d0
      blo f_vers
      moveq #!gdpvers,d7
      trap #1
      tst.b d0
      beq f_vers
      moveq #!curoff,d7
      trap #1

      bsr draw                        * Grafik ausgeben
      lea text2+4(pc),a0
      lea filespezb(pc),a1            * Filespez. in Buffer kopieren
m1:
      move.b (a0)+,(a1)+
      bne.s m1
      lea tagbuf(pc),a0
      clr.w (a0)                      * Anz. der markierten files =0
m15:
      move.l #$280001,d6              * Zûhler fýr Rechteck =1
m54:
      bsr getdir
      tst.b d0
      beq.s m13
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      bne return
      bra.s m15
m13:
      moveq #72,d7
      trap #6                         * Diskinformation
      tst.b d0                        * A0 zeigt nun auf Tabelle
      beq.s m14
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      bne return
      bra.s m13
m14:
      movea.l a0,a1
      move.l 24(a1),d0                * Anzahl freier Bytes
      lea anzbuf(pc),a0
      moveq #!print8d,d7
      trap #1
      lea anzbuf(pc),a0
      moveq #$11,d0
      move #415,d1
      move #200,d2
      moveq #!write,d7
      trap #1
      move.l 8(a1),d0                 * Anzahl belegter Eintrûge
      lea totfile(pc),a0
      move.b d0,(a0)                  * Total Files speichern
      lea anzbuf(pc),a0
      moveq #!print4d,d7
      trap #1
      lea anzbuf(pc),a0
      moveq #$11,d0
      move #433,d1
      move #180,d2
      moveq #!write,d7
      trap #1

      bsr ausgabe                     * Inhaltsverzeichnis ausgeben
      clr d0
      lea anzfile(pc),a1
      move.b anzfile(pc),d0           * Matching Files holen
      lea anzbuf(pc),a0
      moveq #!print4d,d7
      trap #1
      lea anzbuf(pc),a0
      moveq #$11,d0
      move #451,d1
      move #160,d2
      moveq #!write,d7
      trap #1
m21:
      lea anzbuf(pc),a0
      move.l #$20202000,(a0)
      moveq #$11,d0
      move #441,d1
      move #140,d2
      moveq #!write,d7
      trap #1
      move tagbuf(pc),d0              * Anzahl der getaggten Files holen
      lea anzbuf(pc),a0
      moveq #!print4d,d7
      trap #1
      lea anzbuf(pc),a0
      moveq #$11,d0
      move #441,d1
      move #140,d2
      moveq #!write,d7
      trap #1
m10:
      lea anzfile(pc),a1
      bsr setrechteck
      moveq #!ci,d7
      trap #1
      cmp.b #$40,d0
      bls.s m46
      cmp.b #$5b,d0
      bhs.s m46
      bset.b #5,d0                    * Klein in Groþbuchstaben umw.
m46:
      bsr setrechteck
      cmp.b #runter,d0                * runter
      bne.s m9
      moveq #1,d7
m11:
      cmp.b (a1),d6
      bhs.s m10
      addq.b #1,d6
      cmp.b #41,d6                    * unten angekommen ?
      blo.s m10
      subq #1,d6                      * Rechteck bleibt auf letzter Zeile
      swap d6
      cmp.b (a1),d6                   * Letzte Zeile schon sichtbar ?
      blo.s m16
      swap d6
      bra.s m10
m16:
      moveq #1,d0
      move d7,-(a7)
      moveq #!setxor,d7
      trap #1
      move (a7)+,d7
      swap d6
      bsr ausgabe                     * Alten Text lüschen
      swap d6
      add.b d7,d6                     * Lastline erhühen
      swap d6
      bsr ausgabe                     * Neuen Text ausgeben
      moveq #0,d0
      move d7,-(a7)
      moveq #!setxor,d7
      trap #1
      move (a7)+,d7
      bra.s m10
m9:
      cmp.b #rauf,d0                  * rauf
      bne.s m112
      move.b #-1,d7
      subq.b #1,d6
      bne.s m10
      addq #1,d6                      * Rechteck bleibt auf erster Zeile
      swap d6
      cmp.b #40,d6                    * Erste Zeile schon sichtbar ?
      bhi.s m16
      swap d6
      bra m10
m112:
      cmp.b #rechts,d0                * nach rechts
      bne.s m115
      add.b #20,d6
      cmp.b #40,(a1)                  * Mehr als 40 Dateien ?
      bhi.s m114
      cmp.b (a1),d6
      bls m10
      move.b (a1),d6                  * Rechteck auf letztes File setzen
      bra m10
m114:
      cmp.b #41,d6                    * unten angekommen ?
      blo m10
      move d6,d7
      move #40,d6
      sub.b d6,d7                     * Rechteck bleibt auf letzter Zeile
      swap d6

      move d6,d0
      add.b d7,d0
      cmp.b (a1),d0                   * Letzte Zeile schon sichtbar ?
      blo m16
      move.b (a1),d7
      sub.b d6,d7                     * Auf letzte zeile positionieren
      bne m16
m113:
      swap d6
      bra m10
m115:
      cmp.b #links,d0
      bne.s m18
      sub.b #20,d6                    * Nach links
      bhi m10
      move.b d6,d7                    * Wert sichern
      move #1,d6                      * Rechteck auf erste Zeile
      swap d6
      move d6,d0
      add.b d7,d0
      subq.b #1,d7
      cmp.b #40,d0
      bhi m16
      moveq #40,d7
      sub.b d6,d7                     * Lastline auf 40
      bne m16                         * Lastline schon auf minimum
      swap d6
      bra m10
m18:
      cmp.b #'t',d0                   * Taggen ?
      bne.s m22
      bsr tag
      bra m21
m22:
      cmp.b #'u',d0                   * Untaggen
      bne m29
      bsr untag
      bra m21
m29:                            * Filespecification
      cmp.b #'f',d0
      bne m35
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      move #415,d1
      move #240,d2
      moveq #$11,d0
      lea filespezb(pc),a0
      moveq #!writelf,d7
      trap #1
      moveq #10,d1
      moveq #15,d2
      lea text8(pc),a0
      moveq #$11,d0
      moveq #!writelf,d7
      trap #1
      moveq #$11,d0
      moveq #120,d1
      moveq #15,d2
      moveq #12,d3
      lea filespezb(pc),a0
      moveq #!readaus,d7
      trap #1
      lea filespezb(pc),a0
      moveq #$11,d0
      moveq #!writelf,d7
      trap #1
      moveq #10,d1
      moveq #15,d2
      lea text8(pc),a0
      moveq #$11,d0
      moveq #!writelf,d7
      trap #1
      bsr ausgabe
      lea filespezb(pc),a0
      moveq #11,d7
      trap #6                         * Alle Eingaben in Groþbuchstaben unwandeln
      move #415,d1
      move #240,d2
      moveq #$11,d0
      lea filespezb(pc),a0
      moveq #!write,d7
      trap #1
      clr d0
      move.b anzfile(pc),d0           * Matching Files holen
      lea anzbuf(pc),a0
      moveq #!print4d,d7
      trap #1
      lea anzbuf(pc),a0
      moveq #$11,d0
      move #451,d1
      move #160,d2
      moveq #!writelf,d7
      trap #1

      moveq #0,d0
      moveq #!setxor,d7
      trap #1
      bra m15
m35:
      cmp.b #'q',d0
      bne m36
      lea quittext(pc),a0             * Quit
      bsr Fehler
      cmp.b #'j',d0
      bne m10
      moveq #!clrscreen,d7
      trap #1
      bra return
m36:
      cmp.b #'l',d0
      bne.s m38
      lea disklogtext(pc),a0          * Log Drive
      bsr fehler
brk:
      cmp.b #'9',d0
      bls.s is_num
      cmp.b #'a',d0
      blo m10
      cmp.b #'z',d0
      bhi m10
      sub.b #'a'-5,d0
      bra.s m38a

is_num:
      sub.b #'0',d0
      bmi m10
m38a: move d0,d2
      cmp.b #5,d0
      blo.s no_hdd
      moveq #5,d0         ; lw num = 5 for HDD partitions
no_hdd:
      moveq #82,d7
      trap #6
      ext.w d0
      lsl.w #4,d0
      cmp.b #1,0(a0,d0.w)             * Prýfen ob LW gýltig
      bne m10
      move d2,d0
      moveq #54,d7
      trap #6                         * Setdrive
      bra start
m38:
      ;cmp.b #$14,d0
      cmp.b #ctrl_t,d0
      bne.s m44
      lea tag(pc),a4                  * CTRL T
m43:
      move.l d6,-(a7)
      move.b anzfile(pc),d3
      subq #1,d3                      * wegen dbra
      move.l #$00010028,d6
m41:
      swap d6
m39:
      jsr (a4)
      cmp.b #39,d6
      bls.s m40
      swap d6
      addq #1,d6
      cmp.b anzfile(pc),d6
      dbhi d3,m41
      bra.s m42
m40:
      addq #1,d6
      cmp.b anzfile(pc),d6
      dbhi d3,m39
m42:
      move.l (a7)+,d6
      bra m21
m44:
      ;cmp.b #$15,d0
      cmp.b #ctrl_u,d0
      bne.s m45
      lea untag(pc),a4                * CTRL U
      movem.l d6,-(a7)
      swap d6
      move d6,d4
      swap d6
      move #1,d6
m64:
      jsr (a4)
      addq #1,d6
      cmp d6,d4
      bhi.s m64
      movem.l (a7)+,d6
      bra.s m43
m45:
      cmp.b #'c',d0
      bne m51                         * Copy File
m49:
      bsr calcline
      lea 0(a0,d1.w),a2               * Zeiger auf File
      movea.l a2,a3
      lea anzbuf1(pc),a0
      bsr get_file+4
      bsr copytaus
      movea.l a3,a2
      clr.b 13(a3)
      bsr built_file
      move.b #' ',13(a3)
      lea anzbuf(pc),a0
      moveq #18,d7
      lea fcbbuf1(pc),a1
      trap #6                         * FCB fýr Zieldatei erstellen
      tst.b d0
      bne   Fehl                      * Fehler aufgetreten, das ganze noch mal
      clr.b 13(a3)
      movea.l a3,a0
      lea fcbbuf2(pc),a1
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      move.b #' ',13(a3)              * Wieder ursprl. zustand im Directory herstellen
      tst.b d0
      bne fehl
      lea fcbbuf1(pc),a1
      moveq #71,d7
      trap #6                         * Fileinfo von Zieldatei
      tst.b d0
      bne.s m50
      lea errtext2(pc),a0
      bsr fehler
      cmp.b #'j',d0
      bne cancel+4
m50:
      lea fcbbuf2(pc),a1
      lea fcbbuf1(pc),a2
      lea mem(pc),a0
      moveq #15,d7
      trap #6                         * File kopieren
      tst.b d0
      beq cancel+4
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq.s m50
      bra cancel+4
fehl:
      lea anzbuf(pc),a0
      moveq #!print2x,d7
      trap #1
      lea anzbuf(pc),a0
      moveq #$22,d0
      moveq #20,d1
      moveq #20,d2
      moveq #!write,d7
      trap #1
      rts
m51:
      cmp.b #'d',d0
      bne m55
m53:
      bsr calcline                    * Delete File
      lea 0(a0,d1.w),a2
      movea.l a2,a0
      clr.b 13(a0)
      moveq #$11,d0
      moveq #82,d1
      moveq #15,d2
      moveq #!writelf,d7
      trap #1
      lea deltext(pc),a0
      bsr fehler
      move d0,-(a7)
      moveq #82,d1
      movea.l a2,a0
      moveq #1,d0                     * Lüschstift
      moveq #!cmd,d7
      trap #1
      moveq #$11,d0
      moveq #!writelf,d7
      trap #1                         * text wieder lüschen
      moveq #0,d0
      moveq #!cmd,d7
      trap #1
      move (a7)+,d0
      cmp.b #'j',d0
      bne.s m52
      lea fcbbuf2(pc),a1
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      tst.b d0
      bne.s m53
      move.b #' ',13(a2)              * Wieder ursprl. zustand im Directory hers
      bsr untag                       * wenn getaggt, dann untaggen

      moveq #17,d7
      trap #6                         * Erase File
      move d0,-(a7)
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr ausgabe
      clr d0
      moveq #!setxor,d7
      trap #1
      move (a7)+,d0
      tst.b d0
      beq.s m52
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq m53
m52:
      move.b #' ',13(a0)              * Wieder ursprl. Zustand im Directory herstellen
      lea anzfile(pc),a1
      bra m54
m55:
      ;cmp.b #03,d0                   * CTRL C
      cmp.b #ctrl_c,d0
      bne m65
      moveq #72,d3
      lea anzbuf1(pc),a0
      move.l #$2a2e2a00,(a0)
      lea text11+11(pc),a1
      bsr copytaus+4
      movem.l d6,-(a7)                * D6 sichern
      lea dirbuf(pc),a0
      move.b anzfile(pc),d5           * Anz. Directoryeintrûge holen
      moveq #1,d3                     * auf 1.File setzen
m56:
      movem.l d3/a0,-(a7)
      cmp.b #'T',22(a0)               * Prýfen ob File getaggt
      bne m63
      bsr calc1
      move d3,-(a7)
      clr.b 13(a2)
      bsr built_file
      move.b #' ',13(a2)
      move (a7)+,d3
      lea anzbuf(pc),a0               * Zieldatei
      moveq #18,d7
      lea fcbbuf1(pc),a1
      trap #6                         * FCB fýr Zieldatei erstellen
      tst.b d0
      bne   Fehl1                     * Fehler aufgetreten, das ganze noch mal
      clr.b 13(a3)
      movea.l a3,a0
      lea fcbbuf2(pc),a1
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      move.b #' ',13(a3)              * Wieder ursprl. zustand im Directory herstellen
      tst.b d0
      bne fehl1
      lea fcbbuf1(pc),a1
      moveq #71,d7
      trap #6                         * Fileinfo von Zieldatei
      tst.b d0
      bne.s m62
      lea errtext2(pc),a0
      bsr fehler
      cmp.b #'j',d0
      bne.s m63-4
m62:
      lea fcbbuf2(pc),a1
      lea fcbbuf1(pc),a2
      lea mem+100(pc),a0
      moveq #15,d7
      trap #6                         * File kopieren
      tst.b d0
      beq.s m63-4
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq m62
      bsr setrechteck                 * Rechteck wieder lüschen
m63:
      movem.l (a7)+,d3/a0
      lea 23(a0),a0                   * Nûchstes File
      addq #1,d3
      cmp.b d3,d5
      bhs m56
m57:
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr ausgabe
      moveq #0,d0
      moveq #!setxor,d7
      trap #1
      move.l (a7)+,d6
      bra cancel1
fehl1:
      lea anzbuf(pc),a0               * Fehlercode ausgeben
      moveq #!print2x,d7
      trap #1                         * und Programm ende
      lea anzbuf(pc),a0
      moveq #$22,d0
      moveq #20,d1
      moveq #20,d2
      moveq #!write,d7
      trap #1
      rts
m65:
      ;cmp.b #$0c,d0
      cmp.b #ctrl_k,d0
      bne m76
      lea deltext1(pc),a0             * CTRL D
      bsr fehler
      move.b d0,d4
      *  movem.l d6,-(a7)                * D6 sichern
      lea dirbuf(pc),a0
      clr d5
      move.b anzfile(pc),d5           * Anz. Directoryeintrûge holen
      moveq #1,d3                     * auf 1.File setzen
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr ausgabe
      clr d0
      moveq #!setxor,d7
      trap #1
m66:
      cmp.b #'T',22(a0)               * Prýfen ob File getaggt
      bne m67
      movem.l d3/a0,-(a7)
      bsr m74
      movea.l a0,a2
      movea #'j',a4
      cmp.b #'j',d4
      bne m69
      clr.b 13(a0)
      moveq #$11,d0
      moveq #82,d1
      moveq #15,d2
      moveq #!writelf,d7
      trap #1
      lea deltext(pc),a0
      bsr fehler
      move d0,-(a7)
      moveq #82,d1
      movea.l a2,a0
      moveq #1,d0                     * Lüschstift
      moveq #!cmd,d7
      trap #1
      moveq #$11,d0
      moveq #!writelf,d7
      trap #1                         * Text wieder lüschen
      moveq #0,d0
      moveq #!cmd,d7
      trap #1
      move (a7)+,d0
      movea  d0,a4
      cmp.b #'j',d0
      bne m68
m69:
      movea.l a2,a0
      lea fcbbuf2(pc),a1
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      tst.b d0
      bne.s m72
      move.b #' ',13(a2)
      bsr untag                       * wenn getaggt, dann untaggen
      moveq #17,d7
      trap #6                         * Erase File
      tst.b d0
      beq.s m68
m72:
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq.s m69
      addq.l #4,a7                    * Stack korrigieren
      bra m70                         * Ende
m68:
      movem.l (a7)+,d3/a0
      move.b #' ',13(a0)
      bsr setrechteck                 * Rechteck wieder lüschen
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr ausgabe
      clr d0
      moveq #!setxor,d7
      trap #1
      move a4,d0
      cmp.b #'j',d0
      bne.s m67
      bsr move_lines
      lea -23(a0),a0
aa:
      subq #1,d5
      subq #1,d3
      move d5,d0
      lea anzfile(pc),a1
      move.b d0,(a1)
      move #451,d1
      move #160,d2                    * Matching Files neu setzen
      bsr m73
      move #140,d2
      move #441,d1
      move tagbuf(pc),d0
      bsr m73                         * Tagged Files neu setzen
      move #180,d2
      move #433,d1
      lea totfile(pc),a1
      subq.b #1,(a1)
      move.b (a1),d0                  * Total Files neu setzen
      bsr m73
m67:
      lea 23(a0),a0                   * Nûchstes File
      addq #1,d3
      cmp.b d3,d5
      bhs m66
m70:
      bra m15
m76:
      cmp.b #'e',d0
      bne m85
m79:                            * Edit Textfile
      bsr calcline
      lea 0(a0,d1.w),a0               * Zeiger auf File
      movea.l a0,a3
      lea anzbuf(pc),a1
      moveq #13,d3                    * Anz. der Stellen
m116:
      move.b (a3)+,d0
      cmp.b #' ',d0
      beq.s m117
      move.b d0,(a1)+
      subq.b #1,d3
      bra.s m116
m117:
      clr.b (a1)

      lea edittext(pc),a0
      moveq #10,d1
      moveq #35,d2
      moveq #$11,d0
      moveq #!write,d7
      trap #1                         * Text ausgeben

      add #60,d1
      moveq #!readaus,d7
      lea anzbuf(pc),a0
      trap #1
      bcs cancel1

      lea anzbuf(pc),a0
      moveq #11,d7                    * Uppercas
      trap #6

      lea fcbbuf2(pc),a1
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      movea.l a0,a2
      tst.b d0
      bne.s m78

      lea mem(pc),a0
      moveq #44,d7                    * Read File
      trap #6
      tst.b d0
      beq.s m77
m78:
      cmp.b #2,d0
      bne.s m118                      * Ok wenn nicht gefunden
      lea mem(pc),a0
      clr (a0)
      bra.s m77
m118:
      cmp.b #99,d0
      bne.s m80
      lea outmem(pc),a0               * zu wenig Speicher, editieren unmüglich
      bsr fehler
      bra m10
m80:
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq m79
      bra m10                         * Ende
m77:
      movem.l d6/a2-a3,-(a7)          * Zur Sicherheit alle Register sichern
      lea mem(pc),a0
      move.l a0,d0
      moveq #!putstx,d7
      trap #1                         * Textstart setzen
      moveq #!edit,d7
      trap #1                         * Editor aufrufen
      bsr draw
      movem.l (a7)+,d6/a2-a3
      lea anzbuf1(pc),a0
      move.l #$20202000,(a0)
      move #415,d1
      move #240,d2
      moveq #$11,d0
      moveq #!write,d7
      trap #1
      lea filespezb(pc),a0
      moveq #!writelf,d7
      trap #1
      lea speichertext(pc),a0         * Frage ob speichern
      bsr fehler
      cmp.b #'j',d0
      beq.s m81
      cmp.b #$0d,d0
      bne m54
m81:
      lea anzbuf(pc),a0
      lea anzbuf1(pc),a1
m119:
      move.b (a0)+,d0
      move.b d0,(a1)+
      cmp.b #'.',d0
      bne.s m119

      move.b #'B',(a1)
      move.b #'A',1(a1)
      move.b #'K',2(a1)
      clr.b 3(a1)
m83:
      lea anzbuf1(pc),a0
      lea fcbbuf1(pc),a1              * FCB fýr *.BAK File erstellen
      moveq #18,d7
      trap #6
      moveq #17,d7
      trap #6                         * Erase File
      tst.b d0
      bpl.s m82
m84:
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq.s m83
      bra return                      * Ende
m82:
      movea.l a1,a2
      lea fcbbuf2(pc),a1
      moveq #21,d7
      trap #6                         * Reaname altes File in *.BAK
      tst.b d0
      bmi.s m84
      lea anzbuf(pc),a0
      lea fcbbuf2(pc),a1
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      lea mem(pc),a0
      moveq #10,d7
      trap #6                         * Tsave
      bra m54
m85:
      cmp.b #'r',d0
      bne m103                       * Rename File
m87:
      bsr calcline
      lea 0(a0,d1.w),a2               * Zeiger auf File
      movea.l a2,a3
      bsr get_file
      lea rentext1(pc),a0
      moveq #10,d1
      moveq #35,d2
      moveq #$11,d0
      moveq #!write,d7
      trap #1
      add #7*6,d1
      lea anzbuf+2(pc),a0
      moveq #!write,d7
      trap #1                         * Filenamen ausgeben
      add d3,d1
      addq #6,d1
      lea copyt3(pc),a0
      moveq #!write,d7
      trap #1
      moveq #12,d3
      add #3*6,d1
      lea anzbuf1(pc),a0              * Zielname einlesen
      movea.l a0,a2
      moveq #!read,d7
      trap #1
      bcs cancel+4
      tst.b (a2)
      beq cancel+4                    * Abbruch wenn keine Eingabe
      subq #1,d4
      movea.l a3,a4
      movea.l a2,a0
      moveq #11,d7
      trap #6                         * Uppercas aufrufen
      lea anzbuf+2(pc),a2
      exg.l a3,a2
      clr.b 13(a2)
      bsr built_file
      move.b #' ',13(a2)
      exg.l a3,a2
      movea.l a2,a0
m88:
      cmpm.b (a4)+,(a2)+
      bne.s m89
      tst.b (a2)
      bne.s m88
      bra cancel+4                    * Quell- und Zieldatei identisch
m89:
      moveq #18,d7
      lea fcbbuf1(pc),a1
      trap #6                         * FCB fýr Zieldatei erstellen
      tst.b d0
      bne m87                         * Fehler aufgetreten, das ganze noch mal
      clr.b 13(a3)
      movea.l a3,a0
      lea fcbbuf2(pc),a1
      movea.l a1,a2
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      move.b #' ',13(a3)              * Wieder ursprl. zustand im Directory herstellen
      tst.b d0
      bne m87
m90:
      lea fcbbuf1(pc),a1
      moveq #71,d7
      trap #6                         * Fileinfo von Zieldatei
      tst.b d0
      bne.s m86
      lea errtext2(pc),a0
      bsr fehler
      cmp.b #'j',d0
      bne cancel+4
      moveq #17,d7
      trap #6                         * Zieldatei lüschen
      tst.b d0
      beq.s m86
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq.s m90
      bra cancel+4
m86:
      exg.l a1,a2
m91:
      moveq #21,d7
      trap #6                         * Rename
      tst.b d0
      beq m91b
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq.s m91
      bra cancel+4
m91b:
      bsr del_line                    * Hier ev. Fehler !!
      bsr untag_tag
      bsr del_line
      bra cancel+4
m103:
      ;cmp.b #$12,d0                   * CTRL R
      cmp.b #ctrl_r,d0
      bne m10
      moveq #72,d3
      lea rentext1(pc),a0
      moveq #10,d1
      moveq #35,d2
      moveq #$11,d0
      moveq #!write,d7
      trap #1
      add #7*6,d1
      lea text11+11(pc),a0
      moveq #!write,d7
      trap #1                         * Filenamen ausgeben
      add d3,d1
      addq #6,d1
      lea copyt3(pc),a0
      moveq #!write,d7
      trap #1
      moveq #12,d3
      add #3*6,d1
      lea anzbuf1(pc),a0              * Zielname einlesen
      movea.l a0,a2
      moveq #!read,d7
      trap #1
      bcs cancel+4
      tst.b (a2)
      beq cancel+4                    * Abbruch wenn keine Eingabe
      subq #1,d4

      movea.l a2,a0
      moveq #11,d7
      trap #6                         * Uppercas aufrufen

      movem.l d6,-(a7)                * D6 sichern
      lea dirbuf(pc),a0
      move.b anzfile(pc),d5           * Anz. Directoryeintrûge holen
      moveq #1,d3                     * auf 1.File setzen
m104:
      movem.l d3-d4/a0,-(a7)
      cmp.b #'T',22(a0)               * Prýfen ob File getaggt
      bne m105
      bsr calc1
      move d3,-(a7)
      clr.b 13(a2)
      bsr built_file
      move.b #' ',13(a2)
      move (a7)+,d3
      movea.l a2,a4
m107:
      lea anzbuf+2(pc),a3
      movea.l a3,a0
m107a:
      cmpm.b (a4)+,(a3)+
      bne.s m106
      tst.b (a3)
      bne.s m107a
      bra m105-4                      * Quell- und Zieldatei identisch
m106:
      movea.l a2,a3
      moveq #18,d7
      lea fcbbuf1(pc),a1
      trap #6                         * FCB fýr Zieldatei erstellen
      tst.b d0
      bne fehl1                       * Fehler aufgetreten
      clr.b 13(a3)
      movea.l a3,a0
      lea fcbbuf2(pc),a1
      movea.l a1,a2
      moveq #18,d7
      trap #6                         * FCB fýr Quelldatei erstellen
      move.b #' ',13(a3)              * Wieder ursprl. zustand im Directory herstellen
      tst.b d0
      bne fehl1
m108:
      lea fcbbuf1(pc),a1
      moveq #71,d7
      trap #6                         * Fileinfo von Zieldatei
      tst.b d0
      bne.s m109
      lea errtext2(pc),a0
      bsr fehler
      cmp.b #'j',d0
      bne m105-4
      moveq #17,d7
      trap #6                         * Zieldatei lüschen
      tst.b d0
      beq.s m109
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq.s m108
      bra cancel+4
m109:
      exg.l a1,a2
m110:
      moveq #21,d7
      trap #6                         * Rename
      tst.b d0
      beq.s m111
      lea errtext(pc),a0
      bsr Fehler                      * Ausgabe Fehlermeldung
      cmp.b #'j',d0                   * und Frage nochmal versuchen
      beq.s m110
      bra.s m105
m111:
      bsr del_line
      bsr untag_tag
      bsr del_line
      bsr setrechteck
m105:
      movem.l (a7)+,d3-d4/a0
      lea 23(a0),a0                   * Nûchstes File
      addq #1,d3
      cmp.b d3,d5
      bhs m104

      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr ausgabe
      clr d0
      moveq #!setxor,d7
      trap #1
      move.l (a7)+,d6
      bra cancel1
f_vers:
      lea verstext(pc),a0
      moveq #7,d7
      trap #6
return:
      rts
move_lines:
      movem.l a0,-(a7)
      bsr calcline                    * D1= Offset auf aktuelles File
      lea 0(a0,d1.w),a0               * Gelüschtes File aus Directory entfernen
      clr d0
      move.b d5,d0
      mulu #23,d0
      sub d1,d0
      subq #1,d0
m75:
      move.b 23(a0),(a0)
      addq.l #1,a0
      dbra d0,m75
      movem.l (a7)+,a0
      rts
del_line:                             * Aktuelle Zeile am Bildschirm lüschen
      movem.l d5-d6/a0,-(a7)
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr calc
      addq #4,d1
      lsr #1,d2
      addq #1,d2
      moveq #!moveto,d7
      trap #1
      clr d6
      bsr m2                          * Zeile lüschen
      clr d0
      moveq #!setxor,d7
      trap #1
      movem.l (a7)+,d5-d6/a0
      rts
untag_tag:
      moveq #$55,d1
      cmp.b #'T',22(a3)
      bne.s m91h
      moveq #$aa,d1
      movem.l d1/a0-a3,-(a7)
      bsr untag
      movem.l (a7)+,d1/a0-a3
m91h:
      * lea mem(pc),a4
      movem.l d0/a0-a3,-(a7)
      lea anzbuf+2(pc),a0
m91c:
      move.b (a0)+,d0
      beq.s m91d
      * move.b (a3),(a4)+               * Alten Namen sichern
      move.b d0,(a3)+
      bra.s m91c
m91d:
      * clr.b (a4)
      cmp.b #$aa,d1
      bne.s m91i
      bsr tag
m91i:
      movem.l (a7)+,d0/a0-a3
      * move.l a3,-(a7)
      * m91e:
      * move.b (a4)+,d1
      * beq.s m91f
      * move.b d1,(a3)+
      * bra.s m91e
      * m91f:
      * movea.l (a7)+,a3
m91a:
      rts
draw:
      moveq #!clr,d7
      trap #1
      clr d1
      clr d2
      clr d3
      moveq #!set,d7
      trap #1
      moveq #!setflip,d7
      trap #1
      move #511,d4
      moveq #1,d5
outer:
      moveq #3,d6
loop:
      move d4,d0
      moveq #!schreite,d7
      trap #1
      move #90,d0
      moveq #!drehe,d7
      trap #1
      dbra d6,loop
      subq #6,d4
      move #3,d1
      move d1,d2
      moveq #!set,d7
      trap #1
      dbra d5,outer
      move #350,d1
      move #3,d2
      move #90,d3
      moveq #!set,d7
      trap #1
      clr d0
      clr d1
      moveq #!setflip,d7
      trap #1
      move #509,d0
      moveq #!schreite,d7
      trap #1
      clr d0
      clr d1
      moveq #!setflip,d7
      trap #1
      lea text1(pc),a0
      bsr write               * Texte ausgeben

      move #385,d1
      move #220,d2
      moveq #!moveto,d7
      trap #1
      moveq #53,d7
      trap #6                 * Aktuelles Laufwerk holen
      add.b #$30,d0           * in ASCII umwandeln
      lea drivebuf(pc),a0
      move.b d0,(a0)+
      move.b #':',(a0)+       * fýr spûter speichern
      clr.b (a0)+
      moveq #!cmd,d7
      trap #1
      moveq #!grapoff,d7
      trap #1
      rts
m73:
      movem.l a0,-(a7)
      lea anzbuf(pc),a0
      moveq #!print4d,d7
      trap #1
      lea anzbuf(pc),a0
      tst.b 1(a0)
      bne.s m71
      move.b #$20,1(a0)
      clr.b 2(a0)
m71:
      moveq #$11,d0
      moveq #!write,d7
      trap #1
      movem.l (a7)+,a0
      rts
calc1:
      swap d6
      move d6,d0
      swap d6
      cmp.b d0,d3
      bhi.s m74a
      sub #39,d0
      cmp.b d0,d3
      bmi.s m74a
      blo.s m74a
      swap d6                 * Aktuelles File ist im Bildfenster enthalten
      move d6,d0              * Lastline nach D0
      swap d6
      sub d3,d0               * Lastline - Akt. File
      neg d0
      add #40,d0
      move d0,d6              * Rechteck auf akt. File setzen
      bra.s m61+4
m74a:
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr ausgabe             * Alten Text lüschen
      moveq #0,d0
      moveq #!setxor,d7
      trap #1
m74:
      move d3,d2
      sub.b #40,d2
      bmi.s m60
      swap d6
      move d3,d6              * Lastline setzen
      swap d6
      move #40,d6             * Rechteck auf letzte Zeile setzen
      bra.s m61
m60:
      swap d6
      move #40,d6
      swap d6
      move d3,d6
m61:
      bsr ausgabe             * Neuen Text ausgeben
      bsr setrechteck
      movea.l a0,a3           * Zeiger sichern
      movea.l a0,a2
      rts
copytaus:
      lea anzbuf1(pc),a1
      lea copyt1(pc),a0       * Text ausgeben
      moveq #10,d1
      moveq #35,d2
      moveq #$11,d0
      moveq #!write,d7
      trap #1
      moveq #10+42,d1
      add d3,d1               * d3 = lûnge des Namens in Pixel
      lea copyt2(pc),a0
      moveq #!write,d7
      trap #1
      move d1,-(a7)
      moveq #46,d1
      movea.l a1,a0
      moveq #!write,d7
      trap #1

      move d3,d4
      move (a7)+,d1
      moveq #$11,d0
      add #18,d1
      moveq #35,d2
      ext.l d4
      divu #6,d4
      moveq #12,d3
      sub d4,d3
      lea anzbuf1(pc),a0
      cmp.l #$2a2e2a00,(a0)
      bne.s m58
      moveq #9,d3
m58:
      movea.l a0,a2
      moveq #!readaus,d7
      trap #1                   * Zieldatei holen
      bcs cancel
      tst.b (a2)
      beq cancel
m59:
      lea copyt3(pc),a0
      moveq #10,d1
      moveq #25,d2
      moveq #$11,d0
      moveq #!write,d7
      trap #1
      add #18,d1
m59a:
      moveq #1,d3
      lea drivebuf(pc),a0
      movea.l a0,a2
      moveq #!readaus,d7
      trap #1                   * Ziellaufwerk holen
      bcs.s cancel
      tst.b (a2)
      beq.s cancel
      cmp.b #':',1(a2)
      bne.s m59a
      lea anzbuf(pc),a0
      move.w drivebuf(pc),(a0)  * Ziellaufwerk vor Dateinamen setzen
      lea anzbuf1(pc),a0
      moveq #11,d7
      trap #6                   * Uppercas aufrufen
      rts
cancel:
      lea 4(a7),a7              * Stack korrigieren
      moveq #1,d0
      moveq #!setxor,d7
      trap #1
      bsr ausgabe
      clr d0
      moveq #!setxor,d7
      trap #1
cancel1:
      lea loesch(pc),a0
      moveq #$11,d0
      moveq #10,d1
      moveq #35,d2
      moveq #!write,d7
      trap #1
      moveq #25,d2
      lea loesch(pc),a0
      moveq #!write,d7
      trap #1
      bra m54
built_file:
      move.l a2,-(a7)
      lea anzbuf+2(pc),a0
      lea anzbuf1(pc),a1
      clr d3
m92:
      cmp.b #8,d3
      bne.s m98
m99b:
      move.b (a1)+,d0
      beq.s m97                      * den rest des Namens lassen
      cmp.b #'.',d0
      bne.s m99b
m99a:
      moveq #5,d3
m99:
      move.b (a2)+,d0
      beq.s m97
      cmp.b #'.',d0
      bne.s m99
      move.b d0,(a0)+
      bra.s m92
m98:
      move.b (a1)+,d0
      beq.s m97                       * keine Filespec = *.*
      cmp.b #'*',d0
      bne.s m93                       * den rest der Zeile lassen
m95:
      move.b (a2)+,d0                 * den Punkt suchen
      move.b d0,(a0)+
      beq.s m96
      addq #1,d3
      cmp.b #'.',d0
      bne.s m95
m96:
      move.b (a1)+,d0
      beq.s m97                      * den rest des Namens lassen
      cmp.b #'.',d0
      bne.s m96
      moveq #5,d3
      bra.s m92
m93:
      cmp.b #'?',d0
      bne.s m94
      cmp.b #'.',(a2)
      beq.s m92
      tst.b (a2)
      beq.s m92
      move.b (a2)+,(a0)+
      addq #1,d3
      bra.s m92
m94:
      cmp.b #'.',d0
      beq.s m99a                      * Extension auch kopieren
m101:
      move.b d0,(a0)+
      addq #1,d3
      tst.b (a2)
      beq.s m92
      cmp.b #'.',(a2)
      beq.s m92
      addq.l #1,a2
      bra.s m92
m97:
      clr.b (a0)
      lea anzbuf+2(pc),a0
      clr.b 13(a0)
      movea.l (a7)+,a2
      rts
get_file:
      lea anzbuf+2(pc),a0
      clr d3                          * Zeichenzûhler =0
m47:
      move.b (a2)+,d0                 * Zielfile aufbauen
      addq #6,d3
      move.b d0,(a0)+
      cmp.b #'.',d0
      bne.s m47
      moveq #2,d0
m48:
      move.b (a2)+,(a0)+              * Extension auch kopieren
      dbra d0,m48
      add #18,d3
      clr.b (a0)
      rts
calcline:
      swap d6
      move d6,d1
      swap d6
      sub.b #41,d1                    * 1.dargestelltes File berechnen
      add.b d6,d1                     * und aktuelle Zeile addieren
      lea dirbuf(pc),a0
      mulu #23,d1                     * x23
      rts
untag:
      bsr.s calcline
      lea tagbuf(pc),a2
      lea 0(a0,d1.w),a0
      cmp.b #'T',22(a0)
      bne return                      * nicht getaggt
      move (a2)+,d2                   * Anzahl der getaggten Files holen
      move.b #$0a,22(a0)              * im Directory untaggen
      subq #1,-2(a2)
      beq.s m28                       * es war das einzige File
      movea.l a0,a3                   * a0 sichern
m26:
      moveq #11,d1                    * 12 Bytes zu vergleichen
m24:
      cmpm.b (a0)+,(a2)+
      bne.s m23
      dbra d1,m24
      subq #1,d2                      * gefunden !
      lsl #2,d2                       * x4= anzahl der Langworte
m25:
      move.l 4(a2),-12(a2)
      addq.l #4,a2                    * nûchstes Langwort
      dbra d2,m25
m28:
      moveq #1,d0
      moveq #!cmd,d7
      trap #1                         * Lüschstift
      bra m27
m23:
      lea 4(a2,d1.w),a2
      movea.l a3,a0
      dbra d2,m26
      lea 4(a7),a7                    * Stack korrigieren
      bra return
tag:
      bsr calcline
      lea tagbuf(pc),a2
      lea 0(a0,d1.w),a0
      cmp.b #'T',22(a0)
      beq return                      * schon getaggt !
      move (a2)+,d1                   * Anz. der getaggten Files holen
      addq #1,-2(a2)
      lsl #4,d1
      lea 0(a2,d1.w),a2
      moveq #11,d1                     * 12 Bytes zu ýbertragen
m19:
      move.b (a0)+,(a2)+
      dbra d1,m19
      clr (a2)             * CR,LF lüschen
      move.b #'T',10(a0)   * auch im Inhaltsverzeichnis als getaggt markieren
m27:
      bsr calc
      subq #8,d1
      lsr #1,d2
      addq #3,d2
      moveq #!moveto,d7
      trap #1
      moveq #$0b,d0
      moveq #!cmd,d7
      trap #1
      moveq #0,d0
      moveq #!cmd,d7
      trap #1                         * Schreibstift
      rts
setrechteck:
      movem.l d0-d4/d6-d7,-(a7)
      cmp.b #40,d6
      bhi.s error
      moveq #1,d0
      moveq #!setxor,d7
      trap #1                        * XOR- Mode setzen
      bsr.s calc
      move #80,d3
      moveq #20,d4
      moveq #6,d0
      moveq #!grafik,d7
      trap #1
      moveq #0,d0
      moveq #!setxor,d7
      trap #1                        * XOR- Mode lüschen
error:
      movem.l (a7)+,d0-d4/d6-d7
      rts
calc:
      move d6,d0
      mulu #20,d0
      move #498,d2
      sub d0,d2                       * nun Y-Koordinate in d2
      cmp.b #20,d6                    * wenn >20 dann 2.Kolonne
      bhi.s m7
      moveq #46,d1
      bra.s m8
m7:
      move #196,d1
      add #400,d2                     * 2.Kolonne
m8:
      rts
ausgabe:
      movem.l d0-d7/a0,-(a7)
      move #50,d1
      move #240,d2
      moveq #!moveto,d7
      trap #1
      lea dirbuf(pc),a0
      swap d6
      sub.b #40,d6                    * 1.Zeile berechnen
      mulu #23,d6
      lea 0(a0,d6),a0
      clr d4
m6:
      clr d6
      tst.b 2(a0)
      beq end
      move.l a0,d3
      bsr.s m2
      movea.l d3,a0
      lea 13(a0),a0                    * Dateilûnge
      add #78,d1
      moveq #!moveto,d7
      trap #1
      sub #78,d1
m3_2:
      moveq #!cmd,d7
      trap #1
      move.b (a0)+,d0
      cmp.b #$0d,d0
      bne.s m3_2

      move.b (a0)+,d0
      cmp.b #'T',d0
      bne.s m20
      sub #12,d1
      addq #2,d2
      moveq #!moveto,d7
      trap #1
      moveq #$0b,d0                    * Taggsymbol ausgeben
      moveq #!cmd,d7
      trap #1
      subq #2,d2
      add #12,d1
m20:
      sub #10,d2
      moveq #!moveto,d7
      trap #1
      addq #1,d4
      cmp #20,d4
      blo m6                           * wenn kleiner dann neue Zeile
      bhi.s m5                         * wenn grüþer dann neue Kolonne
      move #200,d1                     * !!
      move #240,d2
      moveq #!moveto,d7
      trap #1
      bra m6
m5:
      cmp #40,d4
      bne m6
end:
      movem.l (a7)+,d0-d7/a0
      rts
m2:                                   * Ausgabe einer Zeile
      move.b (a0)+,d0                 * Zeichen laden
      addq #1,d6                      * Zeichenzûhler
      cmp.b #'.',d0
      bne.s m3
      moveq #8,d0
      sub d6,d0
      bmi.s on
      move d0,d5
m4:
      add #48,d1
      moveq #!moveto,d7
      trap #1
      sub #48,d1
on:
      moveq #'.',d0
m3:

      moveq #!cmd,d7
      trap #1
      cmp.b #$20,d0                    * !!
      bne.s m2
      rts
write:
      move (a0)+,d1
      beq.s ret
      move (a0)+,d2
      moveq #$11,d0
      moveq #!write,d7
      trap #1
write1:
      move.b (a0)+,d0
      bne.s write1
      bra.s write
ret:
      rts
getdir:
      movem.l d1-d3/d7/a0-a1,-(a7)
      move #3000,d1
      moveq #1,d2                     * Auch Lûnge einlesen
      moveq #1,d3
      lea dirbuf(pc),a0
      lea filespezb(pc),a1
      moveq #74,d7
      trap #6
      lea anzfile(pc),a1
      clr.b (a1)
      lea dirbuf+2(pc),a0
m17:
      tst.b (a0)
      beq.s end1
      lea 23(a0),a0                   * weil mit Lûnge
      addq.b #1,(a1)
      bra.s m17
end1:
      movem d0,-(a7)                  * Rýckgabecode sichern
      lea anzfile(pc),a1
      clr d1
      move.b (a1),d1                  * Anzahl der Directoryeintrûge
      lea tagbuf(pc),a0
      move (a0)+,d0                   * Anzahl der getaggten Files
      beq.s end2                      * keine Files getaggt
      subq #1,d0                      * fýr dbra
      move d1,d3
m30:
      lea dirbuf(pc),a1
m33:
      moveq #11,d2                    * 12 Bytes zu vergleichen
m31:
      cmpm.b (a0)+,(a1)+
      bne.s m32
      dbra d2,m31
      move.b #'T',10(a1)              * gefunden, File markieren !!
      addq.l #4,a0                    * Nûchstes File
      bra.s m34
m32:
      lea 11(a1,d2.w),a1
      * lea -16(a0),a0
      lea -12(a0,d2.w),a0
      subq.b #1,d1
      bne.s m33                       * Mit nûchstem File vergleichen
      lea 16(a0),a0                   * Nûchstes getaggtes File
m34:
      move d3,d1
      dbra d0,m30
end2:
      movem (a7)+,d0
      movem.l (a7)+,d1-d3/d7/a0-a1
      rts
fehler:
      movem.l a0,-(a7)
      moveq #10,d1
      moveq #15,d2
      moveq #$11,d0
      moveq #!writelf,d7
      trap #1                           * Fehlertext ausgeben
      moveq #42,d1
      moveq #23,d2
      moveq #!setcurxy,d7
      trap #1
      moveq #!curon,d7
      trap #1
      moveq #!ci,d7
      trap #1
      cmp.b #'A',d0
      blo.s m37
      cmp.b #'Z',d0
      bhi.s m37

;      cmp.b #$60,d0
;      bls.s m37
      bset #5,d0        ; to_lower
m37:
      movem.l (a7)+,a0
      movem d0,-(a7)
      moveq #!curoff,d7
      trap #1
      moveq #1,d0
      moveq #!cmd,d7
      trap #1
      moveq #10,d1
      moveq #15,d2
      moveq #$11,d0
      moveq #!writelf,d7
      trap #1
      moveq #0,d0
      moveq #!cmd,d7
      trap #1
      movem (a7)+,d0
      rts
text1: dc.w 355,240
dc.b 'Filespec.',0
text2: dc.w 415,240
dc.b '*.*',0
text3: dc.w 355,220
dc.b 'DISK ',0
text4: dc.w 355,200
dc.b 'Available        Bytes ',0
text5: dc.w 355,180
dc.b 'Total Files: ',0
text6: dc.w 355,160
dc.b 'Matching Files:  ',0
text7: dc.w 355,140
dc.b 'Tagged Files:',0
text9: dc.w 355,100
dc.b '(T)ag File ',0
text10: dc.w 355,90
dc.b '(U)ntag File ',0
text11: dc.w 355,80
dc.b '(C)opy Tagged Files',0
text12: dc.w 355,70
dc.b '(D)elete Tagged Files',0
text13: dc.w 355,60
dc.b '(R)ename Tagged Files',0
text14: dc.w 355,50
dc.b '(L)og Drive',0
text15: dc.w 355,40
dc.b '(E)dit File',0
text16: dc.w 355,30
dc.b '(F)ilespecification',0
text17: dc.w 355,20
dc.b '(Q)uit ',0,0,0
errtext: dc.b 'Diskettenfehler, nochmal versuchen (j/n)',0
text8: dc.b 'Filespecification ',0
quittext: dc.b 'Quit  (j/n) ?',0
disklogtext: dc.b 'Log Drive ?',0
copyt1: dc.b 'Copy ',0
copyt2: dc.b 'as',0
copyt3: dc.b 'to ',0
errtext2: dc.b 'Datei existiert bereits, ýberschreiben ?',0
loesch: dc.b '                                          ',0
deltext: dc.b 'Delete File ',0
deltext1: dc.b 'Bei jedem File fragen ?',0
outmem: dc.b 'Zu wenig Speicher fýr ganze Datei (Taste- weiter)',0
Speichertext: dc.b 'Text Speichern ?  RET=ja',0
rentext1: dc.b 'Rename ',0
edittext: dc.b 'Edit File ',0
verstext: dc.b 'Sie benutzen leider eine Jados oder Grundprogrammversion',$d,$a
dc.b 'die eine zu niedrige Versionsnummer besitzt, oder die alte GDP.',$d,$a
dc.b 'Dieses Programm benütigt das Grundprogramm ab V6.0 und Jados ab V3.02,'
dc.b $d,$a,'sowie die neue GDP- Hardscroll.',$d,$a,$d,$a,0
anzfile: ds.b 1
buffer:ds.b 1
totfile: ds.b 1
filespezb: ds.b 15
ds 0
drivebuf: ds.b 4
anzbuf: ds.b 20
anzbuf1: ds.b 16
dirbuf: ds.b 3000
tagbuf: ds.b 2000
fcbbuf1: ds.b 48
fcbbuf2: ds.b 48
mem:
end
