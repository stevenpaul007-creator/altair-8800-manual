#!/usr/bin/make -f
# Written by Kevin Cole <ubuntourist@hacdc.org> 2020.10.17 (kjc)
#
# This takes Altair-8800 assembler source files and produces:
#
#    - an object file                                 (.p)
#    - an Intel HEX file                              (.hex)
#    - a  binary executable                           (.bin)
#    - a  list report file with octal       op codes  (.oct.lst)
#    - a  list report file with hexadecimal op codes  (.oct.lst)
#    - an include(?) file -- thus far, empty          (.inc)
#
# To use:
#
#        make         # to generate for all .asm files
# or     make root    # (where "root" is the root of a specific "root.asm")
# or     make clean   # to remove all generated files
#
############################################################################

SHELL = /bin/bash
OBJECTS := $(patsubst %.asm,%,$(wildcard *.asm))

.PHONY : all
all : $(OBJECTS)

.PHONY : clean
clean :
	-rm -f	*.hex	 \
		*.bin	 \
		*.lst	 \
		*.inc	 \
		*.p

% : %.asm
	asl -a -cpu 8080 -L -listradix  8 $<
	mv $@.lst $@.oct.lst
	asl -a -cpu 8080 -L -listradix 16 $<
	mv $@.lst $@.hex.lst
	p2hex $@.p
	p2bin $@.p
