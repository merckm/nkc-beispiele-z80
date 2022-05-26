ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: mehrkreise.cas

mehrkreise.cas: mehrkreise.bin
	python3 $(CASCONVERTER) $^

mehrkreise.bin: mehrkreise.asm
	$(ASM) -dotdir -Fbin -L mehrkreise.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
