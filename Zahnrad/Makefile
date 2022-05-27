ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: zahnrad.cas

zahnrad.cas: zahnrad.bin
	python3 $(CASCONVERTER) $^

zahnrad.bin: zahnrad.asm
	$(ASM) -dotdir -Fbin -L zahnrad.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
