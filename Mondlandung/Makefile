ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: mondlandung.cas

mondlandung.cas: mondlandung.bin
	python3 $(CASCONVERTER) $^

mondlandung.bin: mondlandung.asm
	$(ASM) -dotdir -Fbin -L mondlandung.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst