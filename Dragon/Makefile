ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: dragon.cas

dragon.cas: dragon.bin
	python3 $(CASCONVERTER) $^

dragon.bin: dragon.asm
	$(ASM) -dotdir -Fbin -L dragon.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
