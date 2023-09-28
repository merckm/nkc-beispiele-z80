ASM=/mnt/d/Sandbox/Historical/VASM/Z80/vasmz80_oldstyle
CASCONVERTER=../../nkc-cas-writer/caswriter.py 

all: gomoku.cas

gomoku.cas: gomoku.bin
	python3 $(CASCONVERTER) $^

gomoku.bin: gomoku.asm
	$(ASM) -dotdir -Fbin -L gomoku.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.cas *.lst
