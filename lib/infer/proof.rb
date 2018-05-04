module Infer

  Proof = Struct.new(:text, :expression) do
    def derive_and_print(lang)
      puts text

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
