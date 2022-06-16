CASCONVERTER=../../nkc-cas-writer/caswriter.py 

files := $(basename $(shell find . -name '*.bas'))
cas_targets = $(addsuffix .cas, $(files))
#.PHONY: ${cas_targets}

cas:  ${cas_targets}
	echo "Alle Basic Programme bearbeitet"

%.cas: %.bas
	python3 $(CASCONVERTER) -b $^

.PHONY: clean

clean:
	rm -f *.cas
