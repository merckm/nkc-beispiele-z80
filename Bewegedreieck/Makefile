ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: bewegedreieck.cas

bewegedreieck.cas: bewegedreieck.bin
	python3 $(CASCONVERTER) $^

bewegedreieck.bin: bewegedreieck.asm
	$(ASM) -dotdir -Fbin -L bewegedreieck.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
