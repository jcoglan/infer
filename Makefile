SHELL := /bin/bash
PATH  := node_modules/.bin:$(PATH)

derived := lib/infer/grammar.rb lib/infer/expression.rb

.PHONY: all clean test

all: $(derived)

clean:
	rm -rf $(derived)

test: all
	@ruby test/eval.rb
	@ruby test/type.rb

%.rb: %.peg
	canopy $< --lang ruby
