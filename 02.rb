module Day02
  class CubeCount
    class << self
      # @param [String] string
      def from_string(string)
        new(
          red: get_color(string, "red"),
          green: get_color(string, "green"),
          blue: get_color(string, "blue")
        )
      end

      private

      # @param [String] string
      # @param [String] color
      # @return [Integer]
      def get_color(string, color)
        return 0 unless string.match?(color_regex(color))
        string.match(color_regex(color))[:count].to_i
      end

      # @param [String] color
      def color_regex(color)
        /(?<count>(\d+)) #{color}/
      end
    end

    attr_reader :red, :green, :blue

    def initialize(red: 0, green: 0, blue: 0)
      @red = red
      @green = green
      @blue = blue
    end

    def power
      red * green * blue
    end

    # @param [CubeCount] other
    def subset?(other)
      red <= other.red && green <= other.green && blue <= other.blue
    end

    def ==(other)
      red == other.red && green == other.green && blue == other.blue
    end
  end

  class Game
    class << self
      # @param [String] input
      # @return [Game]
      def from_string(input)
        new(
          id: get_id(input),
          rounds: get_rounds(input)
        )
      end

      private

      # @param [String] input
      # @return [Integer]
      def get_id(input)
        input.match(/Game (?<id>\d+)/)[:id].to_i
      end

      # @param [String] input
      # @return [Array<CubeCount>]
      def get_rounds(input)
        get_cube_count_strings(input).map { |round| CubeCount.from_string(round) }
      end

      def get_cube_count_strings(input)
        input.split(":")[1].split(";").map(&:strip)
      end
    end

    attr_reader :id, :rounds

    # @param [Integer] id
    def initialize(id:, rounds: [])
      @id = id
      @rounds = rounds
    end

    # @param [CubeCount] cube_count
    def subset?(cube_count)
      rounds.all? { |round| round.subset?(cube_count) }
    end

    # @return [CubeCount]
    def minimum_cube_count
      CubeCount.new(
        red: rounds.map(&:red).max,
        green: rounds.map(&:green).max,
        blue: rounds.map(&:blue).max
      )
    end
  end

  class << self
    def part_one(input)
      base_count = CubeCount.new(red: 12, green: 13, blue: 14)
      get_games(input).select { |game| game.subset?(base_count) }.sum(&:id)
    end

    def part_two(input)
      get_games(input).map(&:minimum_cube_count).sum(&:power)
    end

    private

    def get_games(input)
      input.map { |line| Game.from_string(line) }
    end
  end
end
