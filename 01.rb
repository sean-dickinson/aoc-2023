module Day01
  class ParsedNumberWithIndex
    include Comparable
    attr_reader :value, :index

    # @param [Integer, NilClass] value
    # @param [Integer, Float] index
    def initialize(value:, index:)
      @value = value
      @index = index
    end

    def <=>(other)
      @index <=> other.index
    end
  end

  INFINITE = ParsedNumberWithIndex.new(value: nil, index: Float::INFINITY)
  NEGATIVE = ParsedNumberWithIndex.new(value: nil, index: -1)

  class CalibrationValue
    class << self
      # @param [String] string
      # @return [CalibrationValue]
      def from_string_with_digits(string)
        first_digit = get_first_digit(string).value
        last_digit = get_last_digit(string).value
        new(first_digit, last_digit)
      end

      def from_string_with_digits_and_words(string)
        first_digit = get_first_value(string)
        last_digit = get_last_value(string)
        new(first_digit, last_digit)
      end

      private

      # @return [ParsedNumberWithIndex]
      def get_first_value(string)
        [get_first_digit(string), get_first_word(string)].min.value
      end

      def get_last_value(string)
        [get_last_digit(string), get_last_word(string)].max.value
      end

      # @return [ParsedNumberWithIndex]
      def get_first_digit(string)
        string.chars.each_with_index do |char, index|
          return ParsedNumberWithIndex.new(value: char.to_i, index: index) if char.match?(/\d/)
        end
        INFINITE
      end

      # @return [ParsedNumberWithIndex]
      def get_last_digit(string)
        string.chars.reverse.each_with_index do |char, index|
          return ParsedNumberWithIndex.new(value: char.to_i, index: get_reverse_index(string, index)) if char.match?(/\d/)
        end
        NEGATIVE
      end

      def get_reverse_index(string, index)
        string.length - index - 1
      end

      # @param [String] string
      # @return [ParsedNumberWithIndex]
      def get_first_word(string)
        words.map { |word|
          get_value_for_first_word(word, string)
        }.min
      end

      # @param [String] string
      # @return [ParsedNumberWithIndex]
      def get_last_word(string)
        words.map { |word|
          get_value_for_last_word(word, string)
        }.max
      end

      def words
        %w[one two three four five six seven eight nine]
      end

      def get_value_for_first_word(word, string)
        index = string.index(word)
        return INFINITE if index.nil?
        value = words.index(word) + 1
        ParsedNumberWithIndex.new(value:, index:)
      end

      def get_value_for_last_word(word, string)
        index = string.rindex(word)
        return NEGATIVE if index.nil?
        value = words.index(word) + 1
        ParsedNumberWithIndex.new(value:, index:)
      end
    end

    attr_reader :first_digit, :last_digit
    # @param [Integer] first_digit
    # @param [Integer] last_digit
    def initialize(first_digit, last_digit)
      @first_digit = first_digit
      @last_digit = last_digit
    end

    # @return [Integer]
    def value
      (@first_digit * 10) + @last_digit
    end
  end

  class << self
    def part_one(input)
      values = input.map { |line| CalibrationValue.from_string_with_digits(line) }
      values.sum(&:value)
    end

    def part_two(input)
      values = input.map { |line| CalibrationValue.from_string_with_digits_and_words(line) }
      values.sum(&:value)
    end
  end
end
