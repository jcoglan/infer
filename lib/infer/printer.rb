module Infer

  Printer = Struct.new(:derivation) do
    PADDING = 4

    attr_reader :box_left, :box_right,
                :conclusion_left, :conclusion_right

    def rule_name
      derivation.rule.to_s
    end

    def conclusion
      @conclusion ||= derivation.conclusions.map(&:to_s).join(', ')
    end

    def parents
      @parents ||= derivation.parents.map { |d| Printer.new(d) }
    end

    def print_simple(d = 0)
      indent = '  ' * d
      puts "#{indent}- [#{rule_name}] #{conclusion}"
      parents.each { |printer| printer.print_simple(d + 1) }
    end

    def print
      plan = Plan.new
      prepare(0)
      generate(plan, 1)
      plan.render
    end

    def prepare(offset)
      parents.inject(offset) do |x, printer|
        printer.prepare(x)
        printer.box_right + PADDING
      end

      if parents.empty?
        parents_width = 0
        premise_left  = offset
        premise_width = 0
      else
        parents_width = parents.last.box_right - parents.first.box_left
        premise_left  = parents.first.conclusion_left
        premise_width = parents.last.conclusion_right - premise_left
      end

      divider_width = [premise_width, conclusion.size].max

      if premise_width < divider_width
        parents.each { |printer| printer.nudge((divider_width - premise_width) / 2) }
        conc_indent = 0
      else
        conc_indent = (divider_width - conclusion.size) / 2
      end

      @box_left  = offset
      @box_right = @box_left + [parents_width, divider_width + 1 + rule_name.size].max

      @divider_left  = premise_left
      @divider_right = @divider_left + divider_width

      @conclusion_left  = @divider_left + conc_indent
      @conclusion_right = @conclusion_left + conclusion.size
    end

    def nudge(offset)
      parents.each { |printer| printer.nudge(offset) }

      @box_right += offset

      @divider_left  += offset
      @divider_right += offset

      @conclusion_left  += offset
      @conclusion_right += offset
    end

    def generate(plan, depth)
      parents.each { |printer| printer.generate(plan, depth + 2) }

      divider = ('-' * (@divider_right - @divider_left)) + ' ' + rule_name

      plan.write(depth + 1, @divider_left, divider)
      plan.write(depth, @conclusion_left, conclusion)
    end

    class Plan
      def initialize
        @lines = []
      end

      def write(depth, offset, text)
        @lines.push('') while @lines.size < depth
        line = @lines[depth - 1]
        line << ' ' * (offset - line.size)
        line << text
      end

      def render
        @lines.reverse_each do |line|
          puts '    ' + line
        end
      end
    end
  end

end
