ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: strasse.cas

strasse.cas: strasse.bin
	python3 $(CASCONVERTER) $^

strasse.bin: strasse.asm
	$(ASM) -dotdir -Fbin -L strasse.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
