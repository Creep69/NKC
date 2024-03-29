****************************************************
*                                                  *
*                      Sysinfo                     *
*                    Version 1.6                   *
*              (c) Jens Mewes 20200801             *
*                                                  *
****************************************************

floppy1   equ $ffffffc1
ser2      equ $fffffff2
ser3      equ $fffffff3
sound0    equ $ffffff50
sound1    equ $ffffff51
centstat  equ $ffffff49
keys      equ $ffffff68
casctrl   equ $ffffffca        * CAS-Neo Control-/Statusregister
casdata   equ $ffffffcb        * CAS-Neo Datenregister
spi_port  equ $ffffff40        * IO-USB Port
colcrt    equ $ffffffac
colcrtd   equ $ffffffad
colcrtb   equ $ffffffae

coladr    equ $a0000


start:
 move #!clrscreen, d7
 trap #1
 move.b #$22, d0
 move #!size, d7
 trap #1
 moveq #11, d1
 moveq #0, d2
 move #!setcurxy, d7
 trap #1
 lea systxt(pc), a0
 bsr write
 move #!crlf, d7
 trap #1
 move.b #$11, d0
 move #!size, d7
 trap #1
 move #!system, d7
 trap #1
 move.l d0, d6                  * Sysinfos in d6
 and.b #$7, d0
 move.b d0, cpumerk
 moveq #0, d1
 moveq #3, d2
 move #!setcurxy, d7
 trap #1
 bsr cpu
 bsr ram
 bsr gp
 move #!crlf, d7
 trap #1
 bsr graf
 bsr zeit
 bsr disk
 bsr scsi
 bsr ide
 bsr sd
 bsr cas
 bsr iousb
 bsr sound
 bsr ser
* bsr lpt
* bsr key
ende:
 move #!csts, d7
 trap #1
 beq.s ende
 move #!ci, d7
 trap #1
 move #!clrscreen, d7
 trap #1
 rts

cpu:
 lea cputxt(pc), a0
 bsr write
 bsr curtab
 move.l d6, d0
 lsr.b #1, d0
 bcc.s cpu001
 lea cputxt1(pc), a0            * 68008
 bra.s cpu010
cpu001:
 lsr.b #1, d0
 bcc.s cpu002
 lea cputxt2(pc), a0            * 68000
 bra.s cpu010
cpu002:
 lsr.b #1, d0
 bcc.s cpu003
 lea cputxt4(pc), a0
 bra.s cpu010
cpu003:
 lea unbek(pc), a0
cpu010:
 bsr write
 move #!crlf, d7
 trap #1

 rts

ram:
 lea mem(pc), a0
 bsr write
 bsr curtab
 suba.l a0, a0
 move #!getram, d7
 trap #1
 movea.l a0, a2                 * RAM-Ende
 move.l a1, d0                  * RAM-Anfang
 lea buffer(pc), a0
 move #!print8x, d7
 trap #1
 lea buffer(pc), a0
 bsr write
 lea minus(pc), a0
 bsr write
 lea buffer(pc), a0
 move.l a2, d0
 subq.l #1, d0
 move #!print8x, d7
 trap #1
 lea buffer(pc), a0
 bsr write
 move #!crlf, d7
 trap #1
 rts

gp:
 lea mem1(pc), a0
 bsr write
 bsr curtab
 move #!getvers, d7
 trap #1
 lea buffer(pc), a0
 bsr prtvers
 lea buffer(pc), a0
 bsr write
 lea r(pc), a0
 bsr write
 move #!getsn, d7
 trap #1
 lea buffer(pc), a0
 move #!print8x, d7
 trap #1
 lea buffer(pc), a0
 bsr write
 lea mem2(pc), a0
 bsr write
 move #!getbasis, d7
 trap #1
 move.l d0, d1
 lea buffer(pc), a0
 move #!print8x, d7
 trap #1
 lea buffer(pc), a0
 bsr write
 move #!crlf, d7
 trap #1
 bsr curtab
 lea check(pc), a0
 bsr write
 movea.l d1, a0
 adda.l #1024, a0
 clr.l d0
 clr.l d1
 move.l #63*1024, d3
gplp01:
 subq.l #1, d3
 bmi.s gplp02
 move.b (a0)+, d1
 add.l d1, d0
 bra.s gplp01
gplp02:
 lea buffer(pc), a0
 move #!print8x, d7
 trap #1
 lea buffer(pc), a0
 bsr write
 move #!crlf, d7
 trap #1
 rts


graf:
 lea graka(pc), a0
 bsr write
 bsr curtab
 btst.l #3, d6
 bne.s graf01
 lea graka1(pc), a0
 bra.s graf10
graf01:
 btst.l #21, d6
 bne.s graf02
 lea graka2(pc), a0
 bra.s graf10
graf02:
 btst.l #22, d6
 bne.s graf03
 lea graka3(pc), a0
 bra.s graf10
graf03:
 lea graka4(pc), a0
graf10:
 bsr write
 movea.l #colcrt, a0
 bsr makeport
 move.b #15, (a0)
 movea.l #colcrtd, a0
 bsr makeport
 move.b (a0), d3
 move.b #$55, (a0)
 nop
 cmp.b #$55, (a0)
 bne.s graf20
 move.b #$aa, (a0)
 nop
 cmp.b #$aa, (a0)
 bne.s graf20
 lea coltxt(pc), a0
 bsr write
graf20:
 move.b d3, (a0)
 move #!crlf, d7
 trap #1
 rts


zeit:
 lea uhr(pc), a0
 bsr write
 bsr curtab
 move.b d6, d0
 and.b #$60, d0                 * nur Uhren lassen
 lsr.b #5, d0
 bne.s zeit01
 lea nv(pc), a0                 * keine Uhr
 bra.s zeit10
zeit01:
 cmp.b #1, d0
 bne.s zeit02
 lea uhr1(pc), a0               * E050
 bra.s zeit10
zeit02:
 cmp.b #2, d0
 bne.s zeit03
 lea uhr2(pc), a0               * Smartwatch
 bra.s zeit10
zeit03:
 lea uhr3(pc), a0               * Dallas
zeit10:
 bsr write
 move #!crlf, d7
 trap #1
 rts

disk:
 lea flop(pc), a0
 bsr write
 bsr curtab
 movea.l #floppy1, a0
 bsr makeport
 move.b (a0), d5
 move.b #$55, (a0)
 move #1000, d3
disk02:
 nop
 dbra d3, disk02
 cmp.b #$55, (a0)
 bne.s disk01
 move.b #$aa, (a0)
 move #1000, d3
disk03:
 nop
 dbra d3, disk03
 cmp.b #$aa, (a0)
 bne.s disk01
 move.b d5, (a0)
 lea v(pc), a0
 bra.s disk10
disk01:
 move.b d5, (a0)
 lea nv(pc), a0
disk10:
 bsr write
 move #!crlf, d7
 trap #1
 rts

scsi:
 lea scsitxt(pc), a0
 bsr write
 bsr curtab
 move #!gets2i, d7
 trap #1
 move.l d0, d1
 move #0, d0
 move #!sets2i, d7
 trap #1
 move #1, d4
 move #!hardtest, d7
 trap #1
 bcs.s scsi01
 lea scsidata(pc), a0
 move #24, d1                   * SCSI-Befehl: Inquiry
 move #1, d4                    * Laufwerks-ID 0
 move #!harddisk, d7
 trap #1
 adda.l #32, a0                 * hinter String springen
 clr.b (a0)                     * Null setzen
 suba.l #24, a0                 * Offset für Name
 bra.s scsi10
scsi01:
 lea nv(pc), a0
scsi10:
 exg d0, d1
 move #!sets2i, d7
 trap #1
 bsr write
 move #!crlf, d7
 trap #1
 rts

ide:
 lea gide(pc), a0
 bsr write
 bsr curtab
 lea gide1(pc), a0
 bsr write
 bsr curtab2
 move #1, d4
 move #!idetest, d7             * IDE-Master
 trap #1
 bcs.s ide05
 adda.l #8, a0                  * Offset für Name
 bsr write
 move #!crlf, d7
 trap #1
 bra.s ide06
ide05:
 lea nv(pc), a0
 bsr write
 bra.s ide08
ide06:
 bsr curtab
 lea gide2(pc), a0
 bsr write
 bsr curtab2
 move #2, d4
 move #!idetest, d7
 trap #1
 bcs.s ide07
 adda.l #8, a0                  * Offset für Name
 bsr write
 bra.s ide08
ide07:
 lea nv(pc), a0
 bsr write
ide08:
 move #!crlf, d7
 trap #1
 rts

sd:
 lea sd1(pc), a0
 btst.l #21, d6
 beq.s sd001
 lea sd2(pc), a0
sd001:
 bsr write
 bsr curtab
 lea sd11(pc), a0
 bsr write
 bsr curtab2
 move #1, d4
 move #!sdtest, d7              * SD0
 trap #1
 bcs.s sd002
 adda.l #8, a0                  * Offset für Name
 bsr write
 move #!crlf, d7
 trap #1
 bra.s sd003
sd002:
 lea nv(pc), a0
 bsr write
 move #!crlf, d7
 trap #1
sd003:
 bsr curtab
 lea sd21(pc), a0
 bsr write
 bsr curtab2
 move #2, d4
 move #!sdtest, d7              * SD1
 trap #1
 bcs.s sd004
 adda.l #8, a0                  * Offset für Name
 bsr write
 bra.s sd005
sd004:
 lea nv(pc), a0
 bsr write
sd005:
 move #!crlf, d7
 trap #1
 rts

ser:
 lea sertxt(pc), a0
 bsr write
 move.l d6, d0
 and.l #$00060000, d0
 beq sernv                      * keine SER
 btst.l #17, d6
 beq ser10                      * keine Standard SER
 bsr curtab
 btst.l #21, d6
 beq.s ser01
 lea sertxt03(pc), a0           * SER-FPGA
 lea serbd1(pc), a2
 bra.s ser02
ser01:
 lea sertxt01(pc), a0           * SER
 lea serbd0(pc), a2
ser02:
 bsr write
 bsr curtab2
 movea.l #ser3, a0
 bsr makeport
 move.b (a0), d0
 move.b d0, d1
 and.l #$f, d0
 subq.l #1, d0
 mulu #6, d0
 lea buffer(pc), a1
 movea.l a2, a0
 move.l 0(a0, d0), (a1)+
 move.w 4(a0, d0), (a1)+
 move.b d1, d0
 and.l #$60, d0
 lsr.l #4, d0
 and.l #$80, d1
 rol.b #1, d1
 movea.l #ser2, a0
 bsr makeport
 move.b (a0), d2
 lsr.l #5, d2
 asl.l #1, d2
 lea serdata(pc), a0
 move 0(a0, d0), (a1)+
 lea serpari(pc), a0
 move 0(a0, d2), (a1)+
 cmp.b #3*2, d0                 * 5 Datenbits
 bne.s ser03
 cmp.b #0, d2                   * keine Parität
 bne.s ser03
 addq.l #1, d1                  * dann 1,5 Stop
ser03:
 mulu #6, d1
 lea serstop(pc), a0
 move.l 0(a0, d1), (a1)+
 move 4(a0, d1), (a1)+
 lea buffer(pc), a0
 bsr write
 move #!crlf, d7
 trap #1
ser10:
 btst.l #18, d6
 beq serex                      * keine SER2
 bsr curtab
 lea sertxt02(pc), a0
 bsr write
 bsr curtab2
 lea v(pc), a0
 bsr write
 bra ser20
sernv:
 bsr curtab
 lea nv(pc), a0
 bsr write
ser20:
 move #!crlf, d7
 trap #1
serex:
 rts

lpt:
 lea prt(pc), a0
 bsr write
 bsr curtab
 movea.l #centstat, a0
 bsr makeport
 move.b (a0), d0
 lea v(pc), a0
 and.b #$1, d0
 beq.s lpt01                    * Drucker vorhanden
 lea nv(pc), a0
lpt01:
 bsr write
 move #!crlf, d7
 trap #1
 rts

sound:
 lea sndtxt(pc), a0
 bsr write
 bsr curtab
 movea.l #sound1, a0
 bsr makeport
 movea.l a0, a1
 movea.l #sound0, a0
 bsr makeport
 move.b #$b, (a0)
 move.b (a0), d5
 move.b #$aa, (a1)
 nop
 cmp.b #$aa, (a0)
 bne.s snd01
 move.b d5, (a1)
snd00:
 lea v(pc), a0
 bra.s snd02
snd01:
 move.b d5, (a1)
 lea nv(pc), a0
snd02:
 bsr write
 move #!crlf, d7
 trap #1
 rts

key:
 lea keytxt(pc), a0
 bsr write
 bsr curtab
 movea.l #keys, a0
 bsr makeport
 move.b (a0), d0
 lea buffer(pc), a0
 move #!print2x, d7
 trap #1
 lea buffer(pc), a0
 bsr write
* lea nv(pc), a0
* cmp.b #$ff, d0
* beq.s key01                    * Tastatur nicht vorhanden
* lea v(pc), a0
*key01:
* bsr write
 move #!crlf, d7
 trap #1
 rts

cas:
 lea castxt(pc), a0
 bsr write
 bsr curtab
 movea.l #casctrl, a0
 bsr makeport
 move.b   #$53, (a0)       * Reset an CAS-Neo
 move.b   #$52, (a0)       * FAT-Modus wählen
 move.l   #$80000, d0           * Timeout
caslp01:
 btst.b   #0, (a0)         * Prüfen ob Antwort
 nop
 bne.s    caslp02               * Zeichen da
 subq.l   #1, d0
 bpl.s    caslp01
 bra.s    casnv                 * Abbruch keine CAS-Neo
caslp02:
 nop
 btst.b   #0, (a0)
 beq.s    caslp02
 movea.l  #casdata, a0
 bsr makeport
 cmp.b    #$39, (a0)            * FAT OK?
 bne.s    casnv                 * Abbruch
casv:
 lea v(pc), a0
 bra.s casex
casnv:
 lea nv(pc), a0
casex:
 bsr write
 move #!crlf, d7
 trap #1
 rts

iousb:
 lea iousbtxt(pc), a0
 bsr write
 bsr curtab
 movea.l #spi_port, a0
 bsr makeport
 lea nv(pc), a1
 bset.b #2, (a0)                ; SPI-Clock
 nop
 btst.b #2, (a0)
 beq.s iousb01
 bclr.b #2, (a0)                ; SPI-Clock
 nop
 btst.b #2, (a0)
 bne.s iousb01
 lea v(pc), a1
iousb01:
 movea.l a1, a0
 bsr write
 move #!crlf, d7
 trap #1
 rts

write:
 movem.l d0/d7/a0, -(a7)
write1:
 move.b (a0)+, d0
 beq.s writeex
 move #!co2, d7
 trap #1
 bra.s write1
writeex:
 movem.l (a7)+, d0/d7/a0
 rts

curtab:
 movem.l d1-d2/d7, -(a7)
 move #!getcurxy, d7
 trap #1
 move #30, d1
 move #!setcurxy, d7
 trap #1
 movem.l (a7)+, d1-d2/d7
 rts

curtab2:
 movem.l d1-d2/d7, -(a7)
 move #!getcurxy, d7
 trap #1
 move #40, d1
 move #!setcurxy, d7
 trap #1
 movem.l (a7)+, d1-d2/d7
 rts

prtvers:                        * Versionsnummer als ASCII nach a0
 movem.l d0-d1, -(a7)
 move.b #'V', (a0)+
 move.b #' ', (a0)+
 rol #4, d0                     * nur unteres Wort wird beachtet
 move.b d0, d1
 and.b #$0f, d1                 * 10er Stelle
 beq.s prt1vers                 * war Null, dann nicht
 add.b #'0', d1
 move.b d1, (a0)+
prt1vers:
 rol #4, d0
 move.b d0, d1
 and.b #$0f, d1                 * 1er Stelle
 add.b #'0', d1
 move.b d1, (a0)+
 move.b #'.', (a0)+             * Der Punkt
 rol #4, d0
 move.b d0, d1
 and.b #$0f, d1                 * 1/10 Stelle
 add #'0', d1
 move.b d1, (a0)+
 rol #4, d0
 and #$0f, d0
 add.b #'0', d0
 move.b d0, (a0)+               * 1/100 Stelle
 clr.b (a0)+                    * und ne Null
 movem.l (a7)+, d0-d1
 rts

makeport:
 movem.l d0-d1, -(a7)
 clr.l d0
 move.b cpumerk, d0
 move a0, d1
 muls d0, d1
 ext.l d1
 movea.l d1, a0
 movem.l (a7)+, d0-d1
 rts

buffer:
 ds.b 80

cpumerk:
 ds.b 1

ds 0

systxt:
 dc.b 'NKC Systeminfo 1.6', 0

peri:
 dc.b 'Peripherie ', 0

unbek:
 dc.b 'unbekannt ', 0

v:
 dc.b 'vorhanden ', 0

nv:
 dc.b 'nicht vorhanden ', 0

minus:
 dc.b ' - ', 0

r:
 dc.b ' Build ', 0

cputxt:
 dc.b 'Prozessor: ', 0
cputxt1:
 dc.b '68008 ', 0
cputxt2:
 dc.b '68000 ', 0
cputxt3:
 dc.b '68010 ', 0
cputxt4:
 dc.b '68020 ', 0
cputxt5:
 dc.b '68030 ', 0
cputxt6:
 dc.b '68040 ', 0
cputxt7:
 dc.b '68060 ', 0

mem:
 dc.b 'Arbeitsspeicher: ', 0
mem1:
 dc.b 'Grundprogramm: ', 0
mem2:
 dc.b '  ab Adresse: ', 0

check:
 dc.b 'Checksumme: ', 0

graka:
 dc.b 'Grafikkarte(n): ', 0
graka1:
 dc.b 'GDP64', 0
graka2:
 dc.b 'GDP64-HS', 0
graka3:
 dc.b 'GDP64HS-FPGA Schwarz/Weiß', 0
graka4:
 dc.b 'GDP64HS-FPGA Farbe', 0

coltxt:
 dc.b ', COL256 ', 0

uhr:
 dc.b 'Echtzeit-Uhr: ', 0
uhr1:
 dc.b 'E050 ', 0
uhr2:
 dc.b 'Smartwatch ', 0
uhr3:
 dc.b 'Dallas DS12887 ', 0

flop:
 dc.b 'Floppy-Controller: ', 0

scsitxt:
 dc.b 'SCSI-Laufwerk: ', 0
scsidata:
 ds.b 36

gide:
 dc.b 'IDE-Laufwerk: ', 0
gide1:
 dc.b 'Master: ', 0
gide2:
 dc.b 'Slave: ', 0

sd1:
 dc.b 'SD-IOE: ', 0
sd2:
 dc.b 'SD-FPGA: ', 0
sd11:
 dc.b 'Karte #0: ', 0
sd21:
 dc.b 'Karte #1: ', 0

sndtxt:
 dc.b 'Soundgenerator: ', 0

sertxt:
 dc.b 'serielle Schnittstelle(n): ', 0
sertxt01:
 dc.b 'SER ', 0
sertxt02:
 dc.b 'SER2 ', 0
sertxt03:
 dc.b 'SER-FPGA ', 0
sertxt04:
 dc.b 'Kanal A ', 0
sertxt05:
 dc.b 'Kanal B ', 0

ds 0

serbd0:
 dc.b '    50'
 dc.b '    75'
 dc.b '109,92'
 dc.b '134,58'
 dc.b '   150'
 dc.b '   300'
 dc.b '   600'
 dc.b '  1200'
 dc.b '  1800'
 dc.b '  2400'
 dc.b '  3600'
 dc.b '  4800'
 dc.b '  7200'
 dc.b '  9600'
 dc.b ' 19200'

serbd1:
 dc.b '    50'
 dc.b '    75'
 dc.b '115200'
 dc.b ' 57600'
 dc.b ' 38400'
 dc.b '   300'
 dc.b '   600'
 dc.b '  1200'
 dc.b '  1800'
 dc.b '  2400'
 dc.b '  3600'
 dc.b '  4800'
 dc.b '  7200'
 dc.b '  9600'
 dc.b ' 19200'

serpari:
 dc.b '-N'
 dc.b '-O'
 dc.b '-X'
 dc.b '-E'

serdata:
 dc.b '-8'
 dc.b '-7'
 dc.b '-6'
 dc.b '-5'

serstop:
 dc.b '-1   ', 0
 dc.b '-2   ', 0
 dc.b '-1,5 ', 0

prt:
 dc.b 'Drucker: ', 0

keytxt:
 dc.b 'Tastatur: ', 0

castxt:
 dc.b 'CAS-Neo: ', 0

iousbtxt:
 dc.b 'IO-USB: ', 0
