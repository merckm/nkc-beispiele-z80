ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: graphtest.cas

graphtest.cas: graphtest.bin
	python3 $(CASCONVERTER) $^

graphtest.bin: graphtest.asm
	$(ASM) -dotdir -Fbin -L graphtest.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
