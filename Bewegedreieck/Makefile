ASM=vasmz80_oldstyle

bewegedreick.bin: bewegedreick.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
