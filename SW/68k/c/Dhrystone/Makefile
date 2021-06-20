# Makefile -- DHRYSTONE program
# Copyright 2000, 2002, 2003 Free Software Foundation, Inc.
# Written by Stephane Carrez (stcarrez@nerim.fr)
# 
# This file is part of GEL.
# 
# GEL is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
# 
# GEL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with GEL; see the file COPYING.  If not, write to
# the Free Software Foundation, 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#
# Host generic commands
RM=rm -f
MV=mv -f
INSTALL=cp

# 68k compiler and tools
DEVC_PREFIX=m68k-elf-
CC=$(DEVC_PREFIX)gcc
AS=$(DEVC_PREFIX)as
SIZE=$(DEVC_PREFIX)size
OBJCOPY=$(DEVC_PREFIX)objcopy
OBJDUMP=$(DEVC_PREFIX)objdump

gccdir = /c/SysGCC/m68k-elf
ISEARCH = -I. 

LIBDIRS =  -L $(gccdir)/m68k-elf/lib/m68000
LIBS =

# Compile with debugging info (-g), with size optimization (-Os)
CFLAGS=-Os -m68000 -Wall -fomit-frame-pointer -nostartfiles -std=gnu99 -D__ECOC__ -Dndrcomp $(ISEARCH)
ASFLAGS=  

# Linker Flags
LDFLAGS= -T rm_ram1.ld -Wl,-Map,dhry.map $(LIBDIRS) $(LIBS) 


# Flags for objcopy tool
OBJCOPY_FLAGS=--only-section=.text \
              --only-section=.rodata \
              --only-section=.vectors \
              --only-section=.data

# List of C sources
CSRCS=  dhry.c 

# Directory where the files are generated to (objects, list files, ...)
OUTDIR=./_out/

# List of objects
#OBJS=$(ASM_SRCS:.s=.o) $(CSRCS:.c=.o)
OBJS=$(CSRCS:.c=.o) 

AOBJ := crt0.o

PROGS=$(OUTDIR)dhry.elf
LIST=$(PROGS:.elf=.lst)

all::	$(PROGS)  create_bin print_codesize

clean_all: clean all

$(PROGS):	$(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -c -o crt0.o ../../nkc_common/crt0.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)
	$(OBJDUMP) -S $(PROGS) > $(LIST)

dhry.s19:    $(PROGS)
	$(OBJCOPY) $(OBJCOPY_FLAGS) --output-target=srec $< $(OUTDIR)$@

create_bin:   dhry.s19
	$(OBJCOPY) --output-target=binary $(OUTDIR)dhry.elf $(OUTDIR)dhry.68k

# print codesize
print_codesize:
	$(SIZE) $(OUTDIR)*.elf

clean::
	$(RM) $(OBJ) $(OUTDIR)*.68k $(OUTDIR)*.lst $(OUTDIR)*.elf $(OUTDIR)*.s19
#	$(RM) $(OBJ) $(AOBJ) *.hex *.srec *.bin *.elf *.map *~ *.lst
	$(RM) $(OBJ) $(AOBJ) *.o
	$(RM) $(OBJ) $(AOBJ) *.map



