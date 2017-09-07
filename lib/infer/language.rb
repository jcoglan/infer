module Infer

  class Language
    attr_reader :rules, :syntax

    def initialize
      @rules  = {}
      @syntax = Syntax.new({})
    end

    def import(language)
      add_syntax(language.syntax)
      @rules = @rules.merge(language.rules)
    end

    def add_syntax(syntax)
      @syntax = syntax + @syntax
    end

    def add_rule(rule, apply_syntax = true)
      rule = @syntax.augment_rule(rule) if apply_syntax and !ENV['NOSYNTAX']
      @rules[rule.name] = rule
    end

    def relation(*symbols)
      Relation.new(self, symbols)
    end

    def derive(target, state = State.new({}))
      streams = @rules.map { |_, rule| rule.match(self, target, state) }
      indexes = Hash[streams.map.with_index.entries]

      interleave(streams) do |stream|
        state = stream.next
        streams.delete_if { |s| indexes[stream] < indexes[s] } if state.cut?
        state.failed? ? nil : state
      end
    end

    def interleave(enums, &block)
      block ||= :next.to_proc

      Enumerator.new { |output|
        until enums.empty?
          loop {
            enum = enums.shift
            state = block.call(enum)
            output.yield(state) if state
            enums << enum
          }
        end
      }
    end
  end

end
