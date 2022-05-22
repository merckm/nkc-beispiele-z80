ASM=vasmz80_oldstyle

groessen.bin: groessen.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
