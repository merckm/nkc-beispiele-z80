ASM=vasmz80_oldstyle

vielstar.bin: vielstar.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
