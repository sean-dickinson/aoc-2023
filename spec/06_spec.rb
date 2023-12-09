require "./06"
RSpec.describe Day06 do
  describe Day06::Boat do
    describe "#distance_for" do
      it "returns the distance for a given charge time" do
        boat = Day06::Boat.new(total_time: 7)
        expect(boat.distance_for(charge_time: 0)).to eq 0
        expect(boat.distance_for(charge_time: 1)).to eq 6
        expect(boat.distance_for(charge_time: 2)).to eq 10
        expect(boat.distance_for(charge_time: 3)).to eq 12
        expect(boat.distance_for(charge_time: 4)).to eq 12
        expect(boat.distance_for(charge_time: 5)).to eq 10
        expect(boat.distance_for(charge_time: 6)).to eq 6
        expect(boat.distance_for(charge_time: 7)).to eq 0
      end
    end
  end

  describe Day06::Race do
    describe "#ways_to_win" do
      it "returns the number of ways to beat the record" do
        race = Day06::Race.new(time_allowed: 7, record_distance: 9)
        expect(race.ways_to_win).to eq 4
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/06.txt", chomp: true)
      expect(Day06.part_one(input)).to eq 288
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/06.txt", chomp: true)
      expect(Day06.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
