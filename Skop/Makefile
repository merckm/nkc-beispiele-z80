ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: skop.cas

skop.cas: skop.bin
	python3 $(CASCONVERTER) -s 0x8400 $^

skop.bin: skop.asm
	$(ASM) -dotdir -Fbin -L skop.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
