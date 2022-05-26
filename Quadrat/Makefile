ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: quadrat.cas

quadrat.cas: quadrat.bin
	python3 $(CASCONVERTER) $^

quadrat.bin: quadrat.asm
	$(ASM) -dotdir -Fbin -L quadrat.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
