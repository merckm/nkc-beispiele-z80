ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: vspiraleb.cas

vspiraleb.cas: vspiraleb.bin
	python3 $(CASCONVERTER) $^

vspiraleb.bin: vspiraleb.asm
	$(ASM) -dotdir -Fbin -L vspiraleb.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
