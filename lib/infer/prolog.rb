module Infer
  module Prolog

    autoload :Builtin,        ROOT.join('prolog', 'builtin')
    autoload :Compound,       ROOT.join('prolog', 'compound')
    autoload :DefiniteClause, ROOT.join('prolog', 'definite_clause')
    autoload :Int,            ROOT.join('prolog', 'int')
    autoload :List,           ROOT.join('prolog', 'list')
    autoload :Parser,         ROOT.join('prolog', 'parser')
    autoload :Program,        ROOT.join('prolog', 'program')

    class Language < Infer::Language
      def derive(target, state = State.new({}))
        value = state.walk(target)
        return super unless Builtin.handle?(value)

        state = Builtin.new(state).evaluate(value)
        return [].each unless state

        states = [state].flatten.map do |state|
          state.clear.derive(Word.new('_'), target, false)
        end

        states.each
      end
    end

    def self.program(program)
      Program.parse(program, :actions => Parser.new)
    end

    def self.extract_vars(goals)
      vars = Set.new
      goals.each { |goal| goal.map_vars { |var| vars.add(var) } }
      vars
    end

    def self.execute_and_print(program, query, options = {})
      vars   = extract_vars([query])
      states = program.derive(query)

      puts "?- #{query}."

      print_results(states, vars, options)
    end

    def self.print_results(states, vars, options)
      any = false

      states = states.take(options[:limit]) if options[:limit]

      states.each do |state|
        any = true
        print_state(state, vars)
      end

      puts "false." unless any
      puts
    end

    def self.print_state(state, vars)
      puts
      Infer.print_derivation(state.build_derivation, :padding => 6)
      puts
      return puts "true." if vars.empty?

      vars.each do |var|
        puts "#{var} = #{state.walk(var)}"
      end
    end

  end
end
