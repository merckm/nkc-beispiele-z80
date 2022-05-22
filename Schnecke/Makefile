ASM=vasmz80_oldstyle

schnecke.bin: schnecke.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
