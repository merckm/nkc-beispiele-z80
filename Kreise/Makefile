ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: kreise.cas

kreise.cas: kreise.bin
	python3 $(CASCONVERTER) $^

kreise.bin: kreise.asm
	$(ASM) -dotdir -Fbin -L kreise.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
