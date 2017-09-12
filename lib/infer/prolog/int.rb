module Infer
  module Prolog

    class Int < Word
      alias :value :name

      def to_s
        value.to_s
      end
    end

  end
end
