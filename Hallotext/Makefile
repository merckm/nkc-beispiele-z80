ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: hallotext.cas

hallotext.cas: hallotext.bin
	python3 $(CASCONVERTER) $^

hallotext.bin: hallotext.asm
	$(ASM) -dotdir -Fbin -L hallotext.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
