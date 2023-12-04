require "./03"
RSpec.describe Day03 do
  describe Day03::PartNumber do
    it "contains a value, row, and column" do
      part_number = Day03::PartNumber.new(1, 0, 0)
      expect(part_number.value).to eq 1
      expect(part_number.row).to eq 0
      expect(part_number.column).to eq 0
    end

    it "can be compared to another part number by value" do
      part_number = Day03::PartNumber.new(1, 0, 0)
      other_part_number = Day03::PartNumber.new(1, 1, 1)
      expect(part_number).to eq other_part_number
    end

    describe "#is_adjacent_to?" do
      it "is true if the other position is in the same row and the columns are adjacent" do
        # .123...
        part_number = Day03::PartNumber.new(123, 0, 1)
        # *123...
        expect(part_number.is_adjacent_to?(0, 0)).to be true
        # .123*..
        expect(part_number.is_adjacent_to?(0, 4)).to be true
      end
      it "is false if the other position is in the same row but the columns are not adjacent" do
        # ..123...
        part_number = Day03::PartNumber.new(123, 0, 2)
        # *..123..
        expect(part_number.is_adjacent_to?(0, 0)).to be false
        # ..123.*..
        expect(part_number.is_adjacent_to?(0, 6)).to be false
      end

      it "is true if the other position is in the row above and the columns are adjacent" do
        # .123...
        part_number = Day03::PartNumber.new(123, 1, 1)
        # *......
        # .123...
        expect(part_number.is_adjacent_to?(0, 0)).to be true
        # .*.....
        # .123...
        expect(part_number.is_adjacent_to?(0, 1)).to be true
        # ..*....
        # .123...
        expect(part_number.is_adjacent_to?(0, 2)).to be true
        # ...*...
        # .123...
        expect(part_number.is_adjacent_to?(0, 3)).to be true
        # ....*..
        # .123...
        expect(part_number.is_adjacent_to?(0, 4)).to be true
      end

      it "is false if the other position is in the row above but the columns are not adjacent" do
        # ..123...
        part_number = Day03::PartNumber.new(123, 1, 2)
        # *......
        # ..123...
        expect(part_number.is_adjacent_to?(0, 0)).to be false

        # ......*..
        # ..123...
        expect(part_number.is_adjacent_to?(0, 6)).to be false
      end

      it "is true if the other position is in the row below and the columns are adjacent" do
        # .123...
        part_number = Day03::PartNumber.new(123, 0, 1)
        # .123...
        # ....*..
        expect(part_number.is_adjacent_to?(1, 4)).to be true
        # .123...
        # ...*...
        expect(part_number.is_adjacent_to?(1, 3)).to be true
        # .123...
        # ..*....
        expect(part_number.is_adjacent_to?(1, 2)).to be true
        # .123...
        # .*.....
        expect(part_number.is_adjacent_to?(1, 1)).to be true
        # .123...
        # *......
        expect(part_number.is_adjacent_to?(1, 0)).to be true
      end

      it "is false if the other position is in the row below but the columns are not adjacent" do
        # ..123...
        part_number = Day03::PartNumber.new(123, 0, 2)
        # ..123...
        # *......
        expect(part_number.is_adjacent_to?(1, 0)).to be false
        # ..123...
        # ......*
        expect(part_number.is_adjacent_to?(1, 6)).to be false
      end
    end
  end

  describe Day03::Schematic do
    it "contains a list of part numbers" do
      schematic = Day03::Schematic.new([
        "467..114..",
        "...*......"
      ])
      expect(schematic.part_numbers).to eq [Day03::PartNumber.new(467, 0, 0)]
    end

    it "contains a list of gears" do
      schematic = Day03::Schematic.new([
        "467..114..",
        "...*......",
        "..35..633"
      ])
      expect(schematic.gears.length).to be 1
      gear = schematic.gears.first
      expect(gear.part_numbers.map(&:value)).to match_array([467, 35])
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/03.txt", chomp: true)
      expect(Day03.part_one(input)).to eq 4361
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/03.txt", chomp: true)
      expect(Day03.part_two(input)).to eq 467835
    end
  end
end
