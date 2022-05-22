ASM=vasmz80_oldstyle

vspiraleb.bin: vspiraleb.asm
	$(ASM) -dotdir -Fbin -L vspiralb.lst $^ -o $@

.PHONY: clean

clean:
	rm -f *.bin *.lst
