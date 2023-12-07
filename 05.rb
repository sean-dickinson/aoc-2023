module Day05
  class Almanac
  end

  class Map
    class << self
      # @param string [String]
      # @return [Map]
      def from(string)
        destination_start, source_start, size = string.split(" ").map(&:to_i)
        source = create_range(source_start, size)
        destination = create_range(destination_start, size)
        new(source: source, destination: destination)
      end

      private

      # @param start [Integer]
      # @param size [Integer]
      # @return [Range]
      def create_range(start, size)
        start...(start + size)
      end
    end

    attr_reader :source, :destination

    # @param source [Range]
    # @param destination [Range]
    def initialize(source:, destination:)
      @source = source
      @destination = destination
    end

    def ==(other)
      source == other.source && destination == other.destination
    end

    def eql?(other)
      self == other
    end

    # @param value [Integer]
    def contains?(value)
      source.include?(value)
    end

    # @param value [Integer]
    def convert(value)
      source_offset = value - source.begin
      destination.begin + source_offset
    end
  end

  class CategoryMapping
    class << self
      # @param array [Array<String>]
      # @return [CategoryMapping]
      def from(array)
        source_category, destination_category = parse_categories(array.shift)
        maps = array.reject(&:empty?).map { |line| Map.from(line) }
        new(
          source_category: source_category,
          destination_category: destination_category,
          maps: maps
        )
      end

      private

      def parse_categories(string)
        # category string looks like "fertilizer-to-water map:"
        # we want to return ["fertilizer", "water"]
        string.match(/(.*)-to-(.*) map:/).captures
      end
    end

    attr_reader :source_category, :destination_category, :maps

    # @param source_category [String]
    # @param destination_category [String]
    # @param maps [Array<Map>]
    def initialize(source_category:, destination_category:, maps:)
      @source_category = source_category
      @destination_category = destination_category
      @maps = maps
    end

    # @param value [Integer]
    # @return [Integer]
    def convert(value)
      @maps.each do |map|
        return map.convert(value) if map.contains?(value)
      end
      value
    end
  end

  class Almanac
    class << self
      def from(input)
        seed_input, *category_maps_input = input
        seeds = parse_seeds(seed_input)
        category_maps = partition_maps(category_maps_input).map { |string| CategoryMapping.from(string) }
        new(seeds: seeds, category_maps: category_maps)
      end

      private

      def parse_seeds(input)
        input.split(":").last.split.map(&:to_i)
      end

      def partition_maps(input)
        input.chunk_while { |before| before != "" }.drop(1)
      end
    end

    # @param seeds [Array<Integer>]
    # @param category_maps [Array<CategoryMapping>]
    def initialize(seeds:, category_maps:)
      @seeds = seeds
      @category_maps = category_maps
    end

    def lowest_location
      mapped_seeds.min
    end

    def lowest_location_as_range
      # TODO: only check the part of the range that is in the first map?
    end

    private

    def seed_ranges
      @seed_ranges ||= @seeds.each_slice(2).map { |start, length| (start...(start + length)) }
    end

    def mapped_seeds
      @seeds.map do |seed|
        @category_maps.inject(seed) { |value, map| map.convert(value) }
      end
    end
  end

  class << self
    # @param input [Array]
    def part_one(input)
      almanac = Almanac.from(input)
      almanac.lowest_location
    end

    def part_two(input)
      almanac = Almanac.from(input, true)
      almanac.lowest_location
    end
  end
end
