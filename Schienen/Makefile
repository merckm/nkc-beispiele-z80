ASM=vasmz80_oldstyle

schienen.bin: schienen.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
