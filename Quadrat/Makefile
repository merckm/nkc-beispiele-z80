ASM=vasmz80_oldstyle

quadrat.bin: quadrat.asm
	$(ASM) -dotdir -Fbin $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin 
