module Infer
  module Prolog

    autoload :Compound, ROOT + '/prolog/compound'
    autoload :List,     ROOT + '/prolog/list'
    autoload :Parser,   ROOT + '/prolog/parser'
    autoload :Program,  ROOT + '/prolog/program'

    def self.program(program)
      Program.parse(program, :actions => Parser.new)
    end

    def self.query(query)
      query = program(query)
      query = query.rules.values.first.conclusion

      vars = []
      query.map_vars { |var| vars << var }

      [query, vars]
    end

    def self.print_results(states, vars)
      any = false
      puts

      states.each do |state|
        any = true
        print_state(state, vars)
      end

      return puts "false.\n\n" unless any
    end

    def self.print_state(state, vars)
      Infer.print_derivation(state.build_derivation)
      puts

      return puts "true.\n\n" if vars.empty?

      vars.each do |var|
        puts "#{var} = #{state.walk(var)}"
      end

      puts
    end

  end
end
