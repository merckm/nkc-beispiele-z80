ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: vielstar.cas

vielstar.cas: vielstar.bin
	python3 $(CASCONVERTER) $^

vielstar.bin: vielstar.asm
	$(ASM) -dotdir -Fbin -L vielstar.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
