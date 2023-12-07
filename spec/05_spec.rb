require "./05"
RSpec.describe Day05 do
  describe Day05::Map do
    describe "#self.from" do
      it "creates a map from a string" do
        map = Day05::Map.from("50 98 2")
        expect(map.source).to eq 98...100
        expect(map.destination).to eq 50...52
      end
    end

    describe "#convert" do
      it "converts a value from the source to the destination" do
        source = 98...100
        destination = 50...52
        category_map = Day05::Map.new(source:, destination:)
        expect(category_map.convert(98)).to eq 50
        expect(category_map.convert(99)).to eq 51
      end
    end

    describe "#contains?" do
      it "returns true if the value is in the source" do
        source = 98...100
        destination = 50...52
        category_map = Day05::Map.new(source:, destination:)
        expect(category_map.contains?(98)).to eq true
        expect(category_map.contains?(99)).to eq true
        expect(category_map.contains?(100)).to eq false
      end
    end
  end

  describe Day05::CategoryMapping do
    describe "#self.from" do
      it "creates a category mapping from an array" do
        input = [
          "fertilizer-to-water map:",
          "49 53 8",
          "0 11 42",
          "42 0 7",
          "57 7 4",
          ""
        ]
        category_mapping = Day05::CategoryMapping.from(input)
        expect(category_mapping.source_category).to eq "fertilizer"
        expect(category_mapping.destination_category).to eq "water"
        expect(category_mapping.maps).to eq [
          Day05::Map.new(source: 53...61, destination: 49...57),
          Day05::Map.new(source: 11...53, destination: 0...42),
          Day05::Map.new(source: 0...7, destination: 42...49),
          Day05::Map.new(source: 7...11, destination: 57...61)
        ]
      end
    end

    describe "#convert" do
      it "converts a value from the source to the destination" do
        map_1 = Day05::Map.new(source: 98...100, destination: 50...52)
        map_2 = Day05::Map.new(source: 50...98, destination: 52...100)
        category_mapping = Day05::CategoryMapping.new(
          source_category: "seed",
          destination_category: "soil",
          maps: [map_1, map_2]
        )
        # included in map 1
        expect(category_mapping.convert(98)).to eq 50
        expect(category_mapping.convert(99)).to eq 51
        # included in map 2
        expect(category_mapping.convert(53)).to eq 55
        # not included in either map
        expect(category_mapping.convert(10)).to eq 10
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/05.txt", chomp: true)
      expect(Day05.part_one(input)).to eq 35
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/05.txt", chomp: true)
      expect(Day05.part_two(input)).to eq 46
    end
  end
end
