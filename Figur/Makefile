ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: figur.cas

figur.cas: figur.bin
	python3 $(CASCONVERTER) $^

figur.bin: figur.asm
	$(ASM) -dotdir -Fbin -L figur.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst