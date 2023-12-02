require "./02"
RSpec.describe Day02 do
  describe Day02::CubeCount do
    context "properties" do
      it "has an attribute for  each color" do
        cube_count = Day02::CubeCount.new(red: 1, green: 2, blue: 3)
        expect(cube_count.red).to eq 1
        expect(cube_count.green).to eq 2
        expect(cube_count.blue).to eq 3
      end

      it "has a an attribute for the 'power' of the cubes" do
        cube_count = Day02::CubeCount.new(red: 1, green: 2, blue: 5)
        expect(cube_count.power).to eq 10
      end
    end

    context "equality" do
      it "is equal to another CubeCount if all of its colors are equal" do
        cube_count = Day02::CubeCount.new(red: 1, green: 2, blue: 3)
        other_cube_count = Day02::CubeCount.new(red: 1, green: 2, blue: 3)
        expect(cube_count).to eq other_cube_count
      end

      it "is not equal to another CubeCount if any of its colors are not equal" do
        cube_count = Day02::CubeCount.new(red: 1, green: 2, blue: 3)
        other_cube_count = Day02::CubeCount.new(red: 1, green: 2, blue: 4)
        expect(cube_count).not_to eq other_cube_count
      end
    end

    context "initialization" do
      it "sets the default values to 0" do
        cube_count = Day02::CubeCount.new
        expect(cube_count.red).to eq 0
        expect(cube_count.green).to eq 0
        expect(cube_count.blue).to eq 0
      end

      describe "self.from_string" do
        it "creates a new instance from a string" do
          cube_count = Day02::CubeCount.from_string("1 red, 2 green, 3 blue")
          expect(cube_count.red).to eq 1
          expect(cube_count.green).to eq 2
          expect(cube_count.blue).to eq 3
        end

        it "can handle strings with only one color" do
          cube_count = Day02::CubeCount.from_string("1 red")
          expect(cube_count.red).to eq 1
          expect(cube_count.green).to eq 0
          expect(cube_count.blue).to eq 0
        end
      end
    end

    describe "#subset?" do
      it "is false if it has any color that is greater than the other CubeCount" do
        cube_count = Day02::CubeCount.new(red: 1, green: 2, blue: 3)
        bigger_cube_count = Day02::CubeCount.new(red: 2, green: 2, blue: 2)
        expect(cube_count.subset?(bigger_cube_count)).to eq false
      end

      it "is true if every color in self is less than or equal to the other CubeCount" do
        cube_count = Day02::CubeCount.new(red: 1, green: 3, blue: 3)
        bigger_cube_count = Day02::CubeCount.new(red: 2, green: 3, blue: 4)
        expect(cube_count.subset?(bigger_cube_count)).to eq true
      end

      it "is true if the other CubeCount has color counts equal to itself" do
        cube_count = Day02::CubeCount.new(red: 3, green: 3, blue: 3)
        other_cube_count = Day02::CubeCount.new(red: 3, green: 3, blue: 3)
        expect(cube_count.subset?(other_cube_count)).to eq true
      end
    end
  end

  describe Day02::Game do
    context "properties" do
      it "has an attribute for the id" do
        game = Day02::Game.new(id: 1)
        expect(game.id).to eq 1
      end

      it "has an attribute called rounds that is a list of cube counts" do
        game = Day02::Game.new(id: 1)
        expect(game.rounds).to eq []
      end
    end

    describe "#minimum_cube_count" do
      it "returns a CubeCount with all colors set to the minimum color" do
        rounds = [
          Day02::CubeCount.new(red: 1, green: 2, blue: 3),
          Day02::CubeCount.new(red: 2, green: 3, blue: 2)
        ]
        game = Day02::Game.new(id: 1, rounds:)
        expect(game.minimum_cube_count).to eq Day02::CubeCount.new(red: 2, green: 3, blue: 3)
      end
    end

    describe "#subset?" do
      it "is true if all rounds are a subset of the given CubeCount" do
        game = Day02::Game.new(
          id: 1,
          rounds: [
            Day02::CubeCount.new(red: 1, green: 2, blue: 3),
            Day02::CubeCount.new(red: 2, green: 3, blue: 4)
          ]
        )
        expect(game.subset?(Day02::CubeCount.new(red: 2, green: 3, blue: 4))).to eq true
      end

      it "is false if any round is not a subset of the given CubeCount" do
        game = Day02::Game.new(
          id: 1,
          rounds: [
            Day02::CubeCount.new(red: 1, green: 2, blue: 3),
            Day02::CubeCount.new(red: 2, green: 3, blue: 4)
          ]
        )
        expect(game.subset?(Day02::CubeCount.new(red: 2, green: 3, blue: 3))).to eq false
      end
    end

    context "initialization" do
      describe "self.from_string" do
        it "creates a new instance from a string with a single round" do
          game = Day02::Game.from_string("Game 1: 1 red, 2 green, 3 blue")
          expect(game.id).to eq 1
          expect(game.rounds).to eq [Day02::CubeCount.new(red: 1, green: 2, blue: 3)]
        end

        it "creates a new instance from a string with multiple rounds" do
          game = Day02::Game.from_string("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
          expect(game.id).to eq 1
          expect(game.rounds).to eq [
            Day02::CubeCount.new(blue: 3, red: 4),
            Day02::CubeCount.new(red: 1, green: 2, blue: 6),
            Day02::CubeCount.new(green: 2)
          ]
        end
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/02.txt", chomp: true)
      expect(Day02.part_one(input)).to eq 8
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/02.txt", chomp: true)
      expect(Day02.part_two(input)).to eq 2286
    end
  end
end
