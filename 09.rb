module Day09
  class Sequence
    class << self
      def from_string(string)
        new(string.split.map(&:to_i))
      end
    end

    attr_reader :numbers

    def initialize(numbers)
      @numbers = numbers
    end

    def last
      numbers.last
    end

    def first
      numbers.first
    end

    def difference
      self.class.new(numbers.each_cons(2).map { |a, b| b - a })
    end

    def empty?
      numbers.all?(&:zero?)
    end

    def extrapolate
      return 0 if empty?
      last + difference.extrapolate
    end

    def extrapolate_backwards
      return 0 if empty?
      first - difference.extrapolate_backwards
    end
  end

  class << self
    def part_one(input)
      input.sum do |line|
        sequence = Sequence.from_string(line)
        sequence.extrapolate
      end
    end

    def part_two(input)
      input.sum do |line|
        sequence = Sequence.from_string(line)
        sequence.extrapolate_backwards
      end
    end
  end
end
