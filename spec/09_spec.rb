require "./09"
RSpec.describe Day09 do
  describe Day09::Sequence do
    it "is initialized with an array of numbers" do
      sequence = Day09::Sequence.new([1, 2, 3])
      expect(sequence.numbers).to eq [1, 2, 3]
    end

    describe "#self.from_string" do
      it "returns a new sequence from a string" do
        sequence = Day09::Sequence.from_string("0 3 6 9 12 15")
        expect(sequence.numbers).to eq [0, 3, 6, 9, 12, 15]
      end
    end

    describe "#difference" do
      it "returns a new sequence with the difference between each number" do
        sequence = Day09::Sequence.new([1, 2, 3])
        expect(sequence.difference.numbers).to eq [1, 1]
      end
    end

    describe "#empty?" do
      it "returns true if the sequence is all 0s" do
        sequence = Day09::Sequence.new([0, 0, 0])
        expect(sequence.empty?).to be true
      end

      it "returns false if the sequence is not all zeros" do
        sequence = Day09::Sequence.new([1, 0, 0])
        expect(sequence.empty?).to be false
      end
    end

    describe "#extrapolate" do
      it "returns 0 if it is an empty sequence" do
        sequence = Day09::Sequence.new([0, 0, 0])
        expect(sequence.extrapolate).to eq 0
      end

      it "returns a constant for a constant sequence" do
        sequence = Day09::Sequence.new([1, 1, 1])
        expect(sequence.extrapolate).to eq 1
      end

      it "returns the sum of the last number of the sequence and the last number of the next difference sequence" do
        sequence = Day09::Sequence.new([0, 3, 6, 9, 12, 15])
        expect(sequence.extrapolate).to eq 18
      end

      it "works regardless of the depth" do
        sequence = Day09::Sequence.new([10, 13, 16, 21, 30, 45])
        expect(sequence.extrapolate).to eq 68
      end
    end

    describe "#extrapolate_backwards" do
      it "returns 0 if it is an empty sequence" do
        sequence = Day09::Sequence.new([0, 0, 0])
        expect(sequence.extrapolate_backwards).to eq 0
      end

      it "returns a constant for a constant sequence" do
        sequence = Day09::Sequence.new([1, 1, 1])
        expect(sequence.extrapolate_backwards).to eq 1
      end

      it "returns the difference between the first number of the sequence and the first number of the next difference sequence" do
        sequence = Day09::Sequence.new([10, 13, 16, 21, 30, 45])
        expect(sequence.extrapolate_backwards).to eq 5
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/09.txt", chomp: true)
      expect(Day09.part_one(input)).to eq 114
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/09.txt", chomp: true)
      expect(Day09.part_two(input)).to eq 2
    end
  end
end
