@echo off

m68k-elf-gcc -std=gnu99 -t -save-temps -mc68000 -mpcrel -fomit-frame-pointer -nostartfiles -Wno-attributes -T ram.ld -Wa,--w,--pcrel,-acdhls=%~n1.asm,--noexecstack %1 -Os -lm

m68k-elf-strip --input-target=elf32-m68k --output-target=symbolsrec -o %~n1.s19 a.out
m68k-elf-objcopy --input-target=srec --output-target=binary %~n1.s19 %~n1.68K
m68k-elf-objdump -d a.out > %~n1.ass
m68k-elf-objdump -h a.out > %~n1.mem
