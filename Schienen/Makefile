ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: schienen.cas

schienen.cas: schienen.bin
	python3 $(CASCONVERTER) $^

schienen.bin: schienen.asm
	$(ASM) -dotdir -Fbin -L schienen.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
