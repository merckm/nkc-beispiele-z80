ASM=vasmz80_oldstyle

blume.bin: blume.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
