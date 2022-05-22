ASM=vasmz80_oldstyle

vielquadrat.bin: vielquadrat.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
