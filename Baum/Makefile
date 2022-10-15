ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: baum.cas

baum.cas: baum.bin
	python3 $(CASCONVERTER) $^

baum.bin: baum.asm
	$(ASM) -dotdir -Fbin -L baum.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
