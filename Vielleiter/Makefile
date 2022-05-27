ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: vielleiter.cas

vielleiter.cas: vielleiter.bin
	python3 $(CASCONVERTER) $^

vielleiter.bin: vielleiter.asm
	$(ASM) -dotdir -Fbin -L vielleiter.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
