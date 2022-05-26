ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: groessen.cas

groessen.cas: groessen.bin
	python3 $(CASCONVERTER) $^

groessen.bin: groessen.asm
	$(ASM) -dotdir -Fbin -L groessen.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
