ASM=vasmz80_oldstyle

strasse.bin: strasse.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
