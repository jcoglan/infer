SHELL := /bin/bash
PATH  := node_modules/.bin:$(PATH)

derived := lib/infer/grammar.rb lib/infer/prolog/program.rb

.PHONY: all clean

all: $(derived)

clean:
	rm -rf $(derived)

%.rb: %.peg
	canopy $< --lang ruby
