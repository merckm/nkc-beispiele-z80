ASM=vasmz80_oldstyle

vielleiter.bin: vielleiter.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
