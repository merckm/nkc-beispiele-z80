ASM=vasmz80_oldstyle

eins.bin: eins.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
