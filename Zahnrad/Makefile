ASM=vasmz80_oldstyle

zahnrad.bin: zahnrad.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
