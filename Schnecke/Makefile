ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: schnecke.cas

schnecke.cas: schnecke.bin
	python3 $(CASCONVERTER) $^

schnecke.bin: schnecke.asm
	$(ASM) -dotdir -Fbin -L schnecke.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
