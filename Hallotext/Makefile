ASM=vasmz80_oldstyle

hallotext.bin: hallotext.asm
	$(ASM) -dotdir -Fbin -L hallotext.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.lst
