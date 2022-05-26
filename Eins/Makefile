ASM=vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

eins.cas: eins.bin
	python3 $(CASCONVERTER) $^

eins.bin: eins.asm
	$(ASM) -dotdir -Fbin -L eins.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
