        org $400

        ; CRC Polynomial
        POLY equ $1021  ; CCITT CRC16 Polynomial
        CPU equ 2

;        ser_base equ $ffe0
        ser_base equ $fff0
        ser_data equ (ser_base)*CPU
        ser_stat equ (ser_base+1)*CPU
        ser_cmd equ  (ser_base+2)*CPU
        ser_ctrl equ (ser_base+3)*CPU
;
        CTRL_BR9600 equ $1e
        CTRL_BR19200 equ $1f
        CTRL_BR38400 equ $13    ; GDP-FPGA only
        CTRL_BR57600 equ $14    ; GDP-FPGA only

        MIN_BS equ 64
        MAX_BS equ 1024
        MAX_HEADER equ 27

MACRO SER_CHK_ERR
        btst.b #2,ser_stat.w
        bne err2
ENDMACRO

start:  moveq #25,d7
        trap #6                 ; Read baudrate from commandline
                                ; A0 points now to parameters
        movea.l a0,a1           ; Store it to A1
        moveq #0,d7
        trap #6                 ; Get length of string
;        lea br_57600(pc),a3     ; Default is 57600
        lea br_19200(pc),a3     ; Default is 19200 (max for original ser)
        tst.w d1
        beq.s default_br
        lea brtable(pc),a2

brsearch:
        move.l (a2)+,d0         ; Read pointer to string
        tst.l d0
        beq.s default_br
        movea.l d0,a3           ; store address in case of an match
        movea.l d0,a0
        moveq #8,d7
        trap #6                 ; strgcomp
        move.l (a2)+,d1         ; Read setting
        tst.b d0
        bne.s brsearch
        move.b d1,d0
        bra.s ser_init
default_br:
        moveq #$1f,d0          ; 19200,n,8,1
        ;moveq #$14,d0           ; 57600,n,8,1
ser_init:
        moveq #$0b,d1
        move.b d0,ser_debug
;        moveq #!siinit,d7
;        trap #1
        bsr siinit
        bsr init_crc

        lea welcome_msg(pc),a0
        moveq #7,d7
        trap #6                 ; Schreibe
        movea a3,a0
        moveq #7,d7
        trap #6                 ; Write Baudrate
        lea part2(pc),a0
        moveq #7,d7
        trap #6                 ; Schreibe
        lea con_stat(pc),a0
        clr.b (a0)

wait_cmd: ;moveq #!sosts,d7
        ;trap #1
        ;beq.s m2
        ;btst.b #4,ser_stat.w
        ;bne.s m2
        moveq #'?',d0
;        moveq #!so,d7
;        trap #1
        bsr ser_so
m2:     moveq #!csts,d7
        trap #1
        beq.s no_char
        moveq #!ci,d7
        trap #1
        cmp.b #'x',d0
        beq exit
no_char:
        btst.b #3,ser_stat.w    ; Byte received?
        beq.s m2
;        moveq #!si,d7
;        trap #1
        bsr ser_si
b1:     cmp.b #'U',d0
        ;bne.s wait_cmd
        beq tx
        cmp.b #'D',d0
        bne.s wait_cmd
        bra.s rx

check_connected:
        lea con_stat(pc),a0
        tst.b (a0)
        bne.s conn_done
        move.b #$ff,(a0)
        lea connected_msg(pc),a0
        moveq #7,d7
        trap #6
conn_done:
        rts


;; **** Receive File
rx:     bsr.s check_connected

        moveq #'O',d0
        bsr ser_so

        bsr rx_header   ; d0=0 -> OK; 1 -> Err; 2 -> Overflow
        tst.b d0
        bne.s rx_fail
        ; Success -> Print Message before ACKing
        lea rx_msg(pc),a0
        lea hdr_fn(pc),a1
        move.l hdr_fs(pc),d5
        bsr print_info
        moveq #1,d0
        bsr pr_crlf
        bra.s rx_payload
rx_fail:
        ; Failure -> Print error Message
;        cmp.b #2,d0
;        bls.s rxf1
;        moveq #1,d0     ; Default error msg
;rxf1:   lea err_str_table(pc),a0
;        subq.b #1,d0
;        lsl.b #2,d0     ; *4
;        ext.w d0
;        movea.l 0(a0,d0.w),a0   ; print message
;        jsr (a0)
        lea err_str_table(pc),a0
        bsr pr_err
        moveq #1,d0
        bsr ack_nack
        bra wait_cmd

err_str_table:
        dc.l rx_err
        dc.l overflow

rx_payload:
        clr.b d0
        bsr ack_nack
        lea bytes_read(pc),a3
        lea hdr_fs(pc),a4
        lea buffer(pc),a0
        clr.l (a3)
        lea progress(pc),a2
rx_loop:
        bsr rx_frame  ; nr of bytes in D4.w afterwards
        tst.b d0
        bne.s rx_fail
        ext.l d4
        move.l (a3),d0
        add.l d4,d0     ; add to bytes aready received
        move.l d0,(a3)
        cmp.l (a4),d0   ; Compare against filesize d0-(a4)
        blo.s rx_loop

rx_done:
        lea hdr_fn(pc),a0

        lea fcb(pc),a1
        moveq #18,d7
        trap #6
        moveq #1,d2     ; Debug
        tst.b d0
        bne ferr

        moveq #16,d7    ; create File
        trap #6
        moveq #2,d2     ; Debug
        tst.b d0
        bne ferr
        lea buffer(pc),a0
        move.l (a4),d2
        lsr.l #8,d2
        lsr.l #2,d2     ; / 1024
        move.w d4,d0
        and.w #$07FF,d0
        beq.s m5
        addq.l #1,d2
m5:     move.l d2,count ; DEBUG
        moveq #57,d7
        trap #6
        moveq #14,d7
        trap #6

done:   lea done_msg(pc),a0
        moveq #7,d7
        trap #6
        bra wait_cmd
exit:   rts

;; **** Transmit file
tx_fail:
        ; Failure -> Print error Message
        lea err_str_table(pc),a0
        bsr pr_err
        bra wait_cmd
tx:
        bsr check_connected
        moveq #'O',d0           ; Send ACK
        bsr ser_so

        bsr rx_header   ; d0=0 -> OK; 1 -> Err; 2 -> Overflow
        tst.b d0
        beq.s tx_hdr_ok
        moveq #'N',d0           ; Send NACK
        bsr ser_so
        bra.s tx_fail
tx_hdr_ok:
        ; Success
        moveq #'O',d0           ; Send ACK
        bsr ser_so
        lea hdr_fn(pc),a0
        cmp.b #':',1(a0)        ; Check if there is a drive letter
        bne.s no_drive
        clr.w d0
        move.b (a0),d0          ; Get drive letter
;        cmp.b #'A',d0
;        bls.s d1
;        sub.b #'A',d0
;        bra.s d2
d1:     sub.b #'0',d0
d2:     moveq #54,d7
;        move.w d0,debug1
        trap #6
        addq.l #2,a0
no_drive:

;*** 1. Anzahl bytes senden (32 bit)
;; 1.1 Datei-info abfragen
;;        lea fname(pc),a0
        lea fcb(pc),a1
        moveq #18,d7    ; fillfcb
        trap #6
        moveq #3,d2     ; Debug
        tst.b d0
        bne.s f_nf
        lea fcb(pc),a1
        moveq #71,d7    ; fileinfo
        trap #6
        moveq #4,d2     ; Debug
        tst.b d0
        bne.s f_nf
        ; dateilûnge ist nun in d1.l
        ; nun als BE zum Host senden
        move.l d1,d0    ; Store file size in d0
        bra.s f_ok
f_nf:   clr.l d1
        clr.l d0
f_ok:
; Transmit Frame holding the file-size (32bit)
        moveq #4,d4
        lea hdr_fs(pc),a0
        move.w d2,-(a7) ; backup error #
        move.l d1,(a0)  ; store fs in header
        clr.l d0        ; no status
        movea.l d0,a2
        bsr tx_frame
        move.w (a7)+,d2
        tst.b d0
        bne tx_fail     ; not recoverable. Abort
        move.l hdr_fs(pc),d5  ; File-size to D5
        tst.l d5        ; if fs==0 -> file not found -> abort
        beq ferr

        lea tx_msg(pc),a0
        lea hdr_fn(pc),a1
        bsr print_info
        moveq #1,d0
        bsr pr_crlf

; 2. File einlesen
; FCB sollte noch aktuell sein
        lea buffer(pc),a0
        lea fcb(pc),a1
        moveq #44,d7
        trap #6
        moveq #5,d2     ; Debug
        tst.b d0
        bne ferr

        lea buffer(pc),a0
        move.b hdr_bs(pc),d3    ; load block-size to D3
        move.l hdr_fs(pc),d5  ; File-size to D5
        lsl.w #8, d3            ; * 256
        ext.l d3
        move.l d3,d4
tx_loop:
        cmp.l d3,d5             ; check if #bytes > bs
        bhi.s tx1
        move.w d5,d4            ; copy remains to d4
tx1:
;        moveq #'.',d0
;       movem.l a0-a2,-(a7)
;       moveq #!co,d7
;       trap #1
;       movem.l (a7)+,a0-a2
        lea progress(pc),a2       ; print status
        bsr tx_frame
        move.b d0,status_debug
        moveq #10,d2            ; Error #
        tst.b d0
        bne tx_fail             ; no recoverable error
;        bne ferr
        sub.l d4,d5             ; substract from fs
        bne.s tx_loop
        ; Successfully Done :-)
        moveq #1,d0
        bsr pr_crlf
        bra done

; A0 points to function-table
; D0.b has error code
pr_err:
        cmp.b #2,d0
        bls.s errf1
        moveq #1,d0     ; Default error msg
errf1:  ;lea tx_err_str_table(pc),a0
        subq.b #1,d0
        lsl.b #2,d0     ; *4
        ext.w d0
        movea.l 0(a0,d0.w),a0   ; print message
        jmp (a0)

; D0.b character used for progress
progress:
;       moveq #'.',d0
        movem.l a0-a2,-(a7)
        moveq #!co,d7
        trap #1
        movem.l (a7)+,a0-a2
        rts

; A0 points to Message
; A1 Points to Filename
; Nr. of bytes to transfer is in D5
print_info:
        moveq #7,d7
        trap #6
;        lea fname(pc),a0
        movea.l a1,a0
        moveq #7,d7
        trap #6

        lea delimiter_msg(pc),a0
        moveq #7,d7
        trap #6
        move.l d5,d0    ; # Bytes holen und ausgeben
        moveq #73,d7
        trap #6
        lea bytes_msg(pc),a0
        moveq #7,d7
        trap #6
        rts

; Print File error Message
; Error # in D2
ferr:   lea err_msg(pc),a0
        moveq #7,d7
        trap #6         ; Print 'Error'

        move.w d2,d0
        moveq #13,d7
        trap #6         ; Print Error #

        lea fname_err(pc),a0
        moveq #7,d7
        trap #6

        lea hdr_fn(pc),a0
        clr.b 14(a0)
        moveq #7,d7
        trap #6         ; Print filename received
        clr.l d0
pr_crlf: lea crlf(pc),a0
        adda.l d0,a0
;        movea.l d0,a0
        moveq #7,d7
        trap #6         ; CRLF

        rts

rx_err: lea rxerr(pc),a0
        moveq #7,d7
        trap #6
        rts

overflow: lea ovf_msg(pc),a0
        moveq #7,d7
        trap #6
        rts

ser_so: btst.b #4,ser_stat.w
        beq.s ser_so
        move.b d0,ser_data.w
        rts

ser_si: move.b ser_stat.w,d0
        btst.b #3,d0
        beq.s ser_si
        lsl.w #8,d0
        move.b ser_data.w,d0
        rts

; if D0.b=0 -> ACK otherwise NACK
ack_nack:
        move.b #'O',d1
        tst.b d0
        beq.s an_ok
        move.b #'N',d1
an_ok:  exg d1,d0
        bsr ser_so
        exg d1,d0
        rts

rx_header: lea header(pc),a0
        lea crc_buffer(pc),a1
        moveq #$FF,d1   ; init CRC
        ; 1. Length (two byte)
        moveq #1,d6
hdr1:
;        btst.b #2,ser_stat.w
;        bne.s err2
        .SER_CHK_ERR

        bsr.s ser_si

        bsr upd_crc
        lsl.w #8,d3
        or.b d0,d3
        dbra d6,hdr1
        cmp.w #MAX_HEADER,d3
        bhi.s err1
        move.w d3,(a0)+
        subq.w #4,d3
        move.w d3,d6

        ; 2. Header opcode 'H'
;        btst.b #2,ser_stat.w
;        bne.s err2
        .SER_CHK_ERR

        bsr.s ser_si
        bsr upd_crc
        cmp.b # 'H',d0
        bne.s err1
        move.b d0,(a0)+

rx1:
;        btst.b #2,ser_stat.w
;        bne.s err2
        .SER_CHK_ERR

        bsr.s ser_si
        move.b d0,(a0)+
        bsr upd_crc
        dbra d6,rx1

        move.w d1, crc_debug
        moveq #0, d0        ; status ok
        tst.w d1
        beq.s rx_crc_ok
        addq.b #1,d0    ; Indicate an error
rx_crc_ok:
        moveq #11,d7
        lea hdr_fn(pc),a0
        trap #6         ; Upper Case
        move.b d0,status_debug
        rts
err1:   moveq #1,d0
        move.b d0, status_debug
        rts
err2:   moveq #2,d0    ; Overflow occured
        move.b d0,status_debug
        rts

; A0 points to buffer
; A2 points to function to print status info. Ignored if null
; nr of bytes received in D4
rx_frame:
        lea crc_buffer(pc),a1
        clr.w len_debug

        ; 1. Length (two byte)
        moveq #1,d6
        moveq #5,d7        ; max. retries
frame2:
        moveq #$FF,d1           ; init CRC
        movea.l a0,a5           ; backup A0 in A5
frame1:
;        btst.b #2,ser_stat.w    ; abort in case of an overflow
;        bne.s err2
        .SER_CHK_ERR

        bsr ser_si

        bsr upd_crc
        lsl.w #8,d3
        or.b d0,d3      ; store len in d3
        dbra d6,frame1
        move.w d3,len_debug

        move.b hdr_bs(pc),d0    ; check against Blocksize
        lsl.w #8,d0
        subq.w #4,d3            ; - header - crc
        cmp.w d0,d3
        bls.s rx_ok1            ; abort transfer in case of an size error
        moveq #1,d0
        bsr ack_nack            ; NACK
        bra.s err1           ; abort transfer -> not recoverable
rx_ok1:

;        move.w d3,(a0)+

        move.w d3,d4            ; store len in D4
        move.w d3,d6
        subq.w #1,d6            ; correct for dbra

rx2:
;        btst.b #2,ser_stat.w
;        bne.s err2
        .SER_CHK_ERR

        bsr ser_si
        move.b d0,(a0)+
        bsr upd_crc
        dbra d6,rx2
        move.w d1,crc_debug
        ; Now read 2 bytes CRC
        moveq #1,d6
f_crc:
;        btst.b #2,ser_stat.w    ; abort in case of an overflow
;        bne.s err2
        .SER_CHK_ERR

        bsr ser_si
        move.b d0,(a0)+

        bsr upd_crc
        dbra d6,f_crc

;       move.w d1, crc_debug
        tst.w d1        ; CRC should be zero now if everything is OK
        beq.s f_crc_ok

        ;; add progress status here
        move.l a2,d0
        tst.l d0
        beq.s np1
        moveq #'!',d0
        jsr (a2)        ; print progress
np1:    moveq #1,d0
        bsr ack_nack
        movea.l a5,a0   ; Restore A0
        dbra d7,frame2  ; Retry in case of an CRC error
        rts             ; max retries reached
f_crc_ok:
        subq.l #2,a0
        move.l a2,d0
        tst.l d0
        beq.s np1
        moveq #'.',d0   ; print progress
        jsr (a2)
        moveq #0,d0
        bsr ack_nack
        rts

; A0 points to buffer
; A2 funtion pointer for status. ignored if null
; nr of bytes to transmit in D4
tx_frame:
        lea crc_buffer(pc),a1
        clr.w len_debug
        movea.l a0,a5           ; Backup A0
        moveq #5,d7        ; max. retries
tx_fr2:
        ; 1. Length (two byte)
        moveq #1,d6
        moveq #$FF,d1           ; init CRC
        movea.l a0,a5           ; backup A0 in A5
        move.w d4,d0
        addq.w #4,d0            ; 2+<len>+2
        rol.w #8,d0             ; swap bytes
tx_fr1:
        bsr ser_so
        bsr upd_crc
        lsr.w #8,d0
        dbra d6,tx_fr1
        move.w d4,d6
        subq.w #1,d6            ; correct for dbra

tx2:    move.b (a0)+,d0
        bsr ser_so
        bsr.s upd_crc
        dbra d6,tx2
        move.w d1,crc_debug
        ; Now send 2 bytes CRC
        moveq #1,d6

        move.w d1,d0
        rol.w #8,d0             ; swap bytes
tx_crc:
        bsr ser_so
        lsr.w #8,d0
;        move.b d0,(a0)+
        dbra d6,tx_crc
; Auf ACK von Host warten
        bsr ser_si
        cmp.b #'O',d0
        beq.s tx_ok
        ; NACK received -> retry
        moveq #'!',d0
        bsr.s tx_stat

        movea.l a5,a0   ; Restore A0
        dbra d7,tx_fr2  ; Retry in case of an CRC error
        moveq #1,d0     ; Error occured
        rts             ; max retries reached
tx_ok:
;       subq.l #2,a0
        moveq #'.',d0
        bsr.s tx_stat
        moveq #0,d0
        rts

tx_stat:
        cmpa #0,a2
        beq.s no_tx_stat
        jmp (a2)
no_tx_stat:
        rts

init_crc: lea crc_buffer(pc),a1
        clr.w d0        ; set b to 0
i1:     move.w d0,d1
        lsl.w #8,d1
        moveq #7,d7
i2:     lsl.w #1,d1
        bcc.s i3
        eor.w #POLY,d1
i3:     dbra d7,i2
        move.w d1,(a1)+
        addq.w #1,d0
        cmp.w #256,d0
        bne.s i1
        lea crc_buffer(pc),a1
        rts

; A1 has to point to CRC_TAB
; d0.b contains byte
; d1.w contains crc
upd_crc: move.w d1,d2
        lsl.w #8,d1
        lsr.w #8,d2
        eor.b d0,d2
        lsl.w #1,d2
        move.w 0(a1,d2.w),d2
        eor.w d2,d1
        rts

siinit: move.b d0,ser_ctrl.w
        move.b d1,ser_cmd.w
        rts


br_9600: dc.b '9600',0
br_19200: dc.b '19200',0
br_38400: dc.b '38400',0
br_57600: dc.b '57600',0
ds 0
brtable: dc.l br_9600, CTRL_BR9600
         dc.l br_19200, CTRL_BR19200
         dc.l br_38400,CTRL_BR38400
         dc.l br_57600,CTRL_BR57600
         dc.l 0,0

welcome_msg: dc.b $d,$a,'RS232-Up/Downloader',$d,$a,'Baudrate: ',0
part2: dc.b $d,$a,'Press x to abort'
dc.b $d,$a,0
connected_msg: dc.b 'Connected',$d,$a,0
rx_msg: dc.b 'Receiving: ',0
tx_msg: dc.b 'Transmitting: ',0
bytes_msg: dc.b 'Bytes',$0d,0
ovf_msg: dc.b $d,$a,'Overflow!',$d,$a,0
done_msg: dc.b $d,$a,'Done. CRC OK',$d,$a,0
crc_err_msg: dc.b $d,$a,'CRC Error!',$d,$a,0
err_msg: dc.b $d,$a,'Error ',0
fname_err: dc.b 'Invalid Filename "',0
rxerr: dc.b $d,$a,'RX Error!',$d,$a,0
delimiter_msg: dc.b ',  ',0
crlf: dc.b '"',$d,$a,0

ds 0
header:
hdr_len: ds.w 1         ;2
hdr_code: ds.b 1        ;1
hdr_bs: ds.b 1          ;1
hdr_fs: ds.l 1          ;4      File Size
hdr_fn: ds.b 16         ;16     Name
hdr_crc: ds.b 2

con_stat: ds.b 1
ds 0
bytes_read: ds.l 1        ; bytes_read

crc_buffer: ds.w 256
count: ds.l 1
len_debug: ds.w 1
blocksize: ds.w 1
crc_debug: ds.w 1
ser_debug: dc.b 1
status_debug: dc.b 1
ds 0
debug1: ds.l 1
ds 0
fcb: ds.b 48
buffer:

