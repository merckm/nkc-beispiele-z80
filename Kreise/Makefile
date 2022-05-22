ASM=vasmz80_oldstyle

kreise.bin: kreise.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
