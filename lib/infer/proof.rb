module Infer

  Proof = Struct.new(:text, :expression, :keyword) do
    def derive_and_print(lang)
      puts text

      if keyword
        loop_evaluation(lang)
      else
        print_proof(lang)
      end
    end

    def loop_evaluation(lang)
      expr     = expression
      relation = lang.relation(keyword)

      loop do
        puts "#{keyword} #{expr}"
        begin
          expr = relation.once(expr)
        rescue Stuck
          break
        end
      end

      puts
    end

    def print_proof(lang)
      proven = false
      states = lang.derive(expression)

      states.each do |state|
        proven = true
        puts
        Infer.print_derivation(state.build_derivation)
        puts
      end

      puts 'FALSE' unless proven
      puts
    end
  end

end
