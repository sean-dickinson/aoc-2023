require "./01"
RSpec.describe Day01 do
  describe Day01::ParsedNumberWithIndex do
    describe "#<=>" do
      it "can sort by index" do
        list = [
          Day01::ParsedNumberWithIndex.new(value: 1, index: 1),
          Day01::ParsedNumberWithIndex.new(value: 2, index: -1),
          Day01::ParsedNumberWithIndex.new(value: 3, index: 3)
        ]
        expect(list.sort.map(&:value)).to eq [2, 1, 3]
      end

      it "has a value of -1 for negative index" do
        expect(Day01::NEGATIVE.index).to eq(-1)
      end

      it "has a value of infinity for positive index" do
        expect(Day01::INFINITE.index).to eq Float::INFINITY
      end
    end
  end

  describe Day01::CalibrationValue do
    describe "#value" do
      it "returns the correct value" do
        expect(Day01::CalibrationValue.new(1, 2).value).to eq 12
        expect(Day01::CalibrationValue.new(9, 9).value).to eq 99
        expect(Day01::CalibrationValue.new(0, 1).value).to eq 1
        expect(Day01::CalibrationValue.new(0, 0).value).to eq 0
      end
    end

    describe "self.#from_string_with_digits" do
      it "creates a new instance from a string by grabbing the first and last digits" do
        table = {
          "1abc2" => [1, 2],
          "pqr3stu8vwx" => [3, 8],
          "a1b2c3d4e5f" => [1, 5],
          "treb7uchet" => [7, 7]
        }
        table.each do |string, digits|
          calibration_value = Day01::CalibrationValue.from_string_with_digits(string)
          expect(calibration_value.first_digit).to eq digits.first
          expect(calibration_value.last_digit).to eq digits.last
        end
      end
    end

    describe "self.#from_string_with_digits_and_words" do
      it "can handle strings with words and digits" do
        string = "two1nine"
        calibration_value = Day01::CalibrationValue.from_string_with_digits_and_words(string)
        expect(calibration_value.first_digit).to eq 2
        expect(calibration_value.last_digit).to eq 9
      end

      it "can do this" do
        string = "5fivezgfgcxbf3five"
        calibration_value = Day01::CalibrationValue.from_string_with_digits_and_words(string)
        expect(calibration_value.first_digit).to eq 5
        expect(calibration_value.last_digit).to eq 5
        expect(calibration_value.value).to eq 55
      end

      it "can handle strings with only words" do
        string = "eightwothree"
        calibration_value = Day01::CalibrationValue.from_string_with_digits_and_words(string)
        expect(calibration_value.first_digit).to eq 8
        expect(calibration_value.last_digit).to eq 3
      end

      it "can handle strings with only digits" do
        string = "1234567890"
        calibration_value = Day01::CalibrationValue.from_string_with_digits_and_words(string)
        expect(calibration_value.first_digit).to eq 1
        expect(calibration_value.last_digit).to eq 0
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/01.txt", chomp: true)
      expect(Day01.part_one(input)).to eq 142
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = %w[
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
      ]
      expect(Day01.part_two(input)).to eq 281
    end
  end
end
