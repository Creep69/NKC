/* Exampe likersript: http://www.hertaville.com/a-sample-linker-script.html */

GROUP(-lbcc -lc -lgcc)

MEMORY {
/* gp : ORIGIN = 0x000000, LENGTH = 0x010000 64 kB GP */
GP_ram : ORIGIN = 0x010000, LENGTH = 0x400 /* 1kB GP ram */
ram : ORIGIN = 0x000000, LENGTH = 0xFFFFF /* 1MB */
}


SECTIONS {

.text : {
_text_sta = . ;
*(.text)
_text_end = ALIGN(0x2) ;
} > ram

.interrupt : {
_int_handler_sta = . ;
*(.int)
_int_end = ALIGN(0x2) ;
} > ram

.data : {
_data_sta = . ;
*(.data)
_data_end = ALIGN(0x2) ;
} > ram

.bss : {
_bss_sta = . ;
*(.bss)
*(COMMON)
_bss_end = ALIGN(0x2);
} > ram
_end = .;

}