ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: blume.cas

blume.cas: blume.bin
	python3 $(CASCONVERTER) $^

blume.bin: blume.asm
	$(ASM) -dotdir -Fbin -L blume.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
