ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: vielquadrat.cas

vielquadrat.cas: vielquadrat.bin
	python3 $(CASCONVERTER) $^

vielquadrat.bin: vielquadrat.asm
	$(ASM) -dotdir -Fbin -L vielquadrat.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
