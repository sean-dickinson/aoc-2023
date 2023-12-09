module Day06
  class RaceList
    def initialize(input)
      @races = parse_input(input)
    end

    def power
      @races.map(&:ways_to_win).reduce(:*)
    end

    private

    def parse_input(input)
      times = parse_line(input.first)
      distances = parse_line(input.last)
      times.zip(distances).map { |time, distance| Race.new(time_allowed: time, record_distance: distance) }
    end

    # @param line [String]
    def parse_line(line)
      line.split(":").last.split.map(&:to_i)
    end
  end

  class BigRaceFactory
    class << self
      def from(input)
        time = parse_line(input.first)
        distance = parse_line(input.last)
        Race.new(time_allowed: time, record_distance: distance)
      end

      def parse_line(line)
        line.split(":").last.split.join("").to_i
      end
    end
  end

  class Race
    def initialize(time_allowed:, record_distance:)
      @time_allowed = time_allowed
      @record_distance = record_distance
    end

    def ways_to_win
      half_ways_to_win * 2 + adjustment
    end

    private

    def half_ways_to_win
      (1..half_time).count do |charge_time|
        boat.distance_for(charge_time: charge_time) > @record_distance
      end
    end

    def half_time
      (@time_allowed / 2).ceil
    end

    def adjustment
      if @time_allowed.even?
        -1
      else
        0
      end
    end

    def boat
      @boat ||= Boat.new(total_time: @time_allowed)
    end
  end

  class Boat
    def initialize(total_time:, speed_multiplier: 1)
      @total_time = total_time
      @speed_multiplier = speed_multiplier
    end

    def distance_for(charge_time:)
      speed(charge_time) * (@total_time - charge_time)
    end

    private

    def speed(charge_time)
      @speed_multiplier * charge_time
    end
  end

  class << self
    def part_one(input)
      RaceList.new(input).power
    end

    def part_two(input)
      race = BigRaceFactory.from(input)
      race.ways_to_win
    end
  end
end
