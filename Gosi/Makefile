CASCONVERTER=../../nkc-cas-writer/caswriter.py 

files := $(basename $(shell find . -name '*.gosi'))
cas_targets = $(addsuffix .cas, $(files))
#.PHONY: ${cas_targets}

cas:  ${cas_targets}
	echo "Alle GOSI Programme bearbeitet"

%.cas: %.gosi
	python3 $(CASCONVERTER) -g $^

.PHONY: clean

clean:
	rm -f *.cas
