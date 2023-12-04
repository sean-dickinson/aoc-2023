require "debug"
module Day03
  class PartNumber
    attr_reader :value, :row, :column

    def initialize(value, row, column)
      @value = value
      @row = row
      @column = column
    end

    def ==(other)
      value == other.value
    end

    def is_adjacent_to?(other_row, other_column)
      is_adjacent_to_row?(other_row) && column_range.include?(other_column)
    end

    def to_s
      value.to_s
    end

    def length
      value.to_s.length
    end

    private

    def column_range
      (column - 1)..(column + length)
    end

    def is_adjacent_to_row?(other_row)
      row == other_row || row == other_row - 1 || row == other_row + 1
    end
  end

  Gear = Data.define(:part_numbers) do
    def ratio
      part_numbers.map(&:value).inject(1, &:*)
    end
  end

  class Schematic
    attr_reader :part_numbers, :gears

    def initialize(rows)
      @part_numbers = []
      @gears = []
      @rows = rows
      parse_part_numbers
      parse_gears
    end

    private

    def parse_gears
      @rows.each_with_index do |row, row_index|
        row.chars.each_with_index do |cell, column_index|
          next unless cell == "*"
          neighboring_part_numbers = @part_numbers.select do |part_number|
            part_number.is_adjacent_to?(row_index, column_index)
          end
          next if neighboring_part_numbers.size != 2
          @gears << Gear.new(part_numbers: neighboring_part_numbers)
        end
      end
    end

    def parse_part_numbers
      @rows.each_with_index do |row, row_index|
        get_numbers_with_indexes(row).each do |number, column_index|
          add_part_number(number, row_index, column_index)
        end
      end
    end

    def get_numbers_with_indexes(row)
      result = []
      row.scan(/\d+/) do |number|
        result << [number, Regexp.last_match.offset(0).first]
      end
      result
    end

    def add_part_number(raw_part_number, row_index, column_index)
      neighbors = get_neighbors_of(raw_part_number, row_index, column_index)
      return if neighbors.empty?
      part_number = PartNumber.new(raw_part_number.to_i, row_index, column_index)
      @part_numbers << part_number
    end

    def get_neighbors_of(part_number, row_index, column_index)
      neighbors = []
      neighbors += get_neighbors_in_same_row(row_index, column_index, part_number.length)
      neighbors += get_neighbors_in_previous_row(row_index, column_index, part_number.length)
      neighbors += get_neighbors_in_next_row(row_index, column_index, part_number.length)
      neighbors.reject { |neighbor| is_invalid_neighbor?(neighbor) }
    end

    def is_invalid_neighbor?(neighbor)
      neighbor.nil? || neighbor == "." || neighbor.match?(/\d+/)
    end

    def get_neighbors_in_same_row(row_index, column_index, length)
      left, right = get_left_and_right_indicies(column_index, length)
      [get_cell(row_index, left), get_cell(row_index, right)]
    end

    def get_neighbors_in_previous_row(row_index, column_index, length)
      return [] if row_index == 0
      left, right = get_left_and_right_indicies(column_index, length)
      (left..right).map do |column|
        get_cell(row_index - 1, column)
      end
    end

    def get_neighbors_in_next_row(row_index, column_index, length)
      return [] if row_index == @rows.length - 1
      left, right = get_left_and_right_indicies(column_index, length)
      (left..right).map do |column|
        get_cell(row_index + 1, column)
      end
    end

    def get_cell(row_index, column_index)
      return nil if row_index < 0 || row_index >= @rows.length
      row = @rows[row_index]
      return nil if column_index < 0 || column_index >= row.length
      row[column_index]
    end

    def get_left_and_right_indicies(column_index, length)
      left = column_index - 1
      right = column_index + length
      [left, right]
    end
  end

  class << self
    def part_one(input)
      schematic = Schematic.new(input)
      schematic.part_numbers.sum(&:value)
    end

    def part_two(input)
      schematic = Schematic.new(input)
      schematic.gears.sum(&:ratio)
    end
  end
end
