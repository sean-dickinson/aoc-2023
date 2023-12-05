require "./04"
RSpec.describe Day04 do
  describe Day04::ScratchOffCard do
    context "properties" do
      it "has a set of winning numbers and played_numbers" do
        card = Day04::ScratchOffCard.new(winning_numbers: [1, 2, 3], played_numbers: [1, 4, 5])
        expect(card.winning_numbers).to eq [1, 2, 3]
        expect(card.played_numbers).to eq [1, 4, 5]
      end

      it "has a card number" do
        card = Day04::ScratchOffCard.new(winning_numbers: [1, 2, 3], played_numbers: [1, 4, 5], card_number: 1)
        expect(card.card_number).to eq 1
      end

      describe "#score" do
        it "returns 1 if there is one match" do
          card = Day04::ScratchOffCard.new(winning_numbers: [1, 2, 3], played_numbers: [1, 4, 5])
          expect(card.score).to eq 1
        end

        it "returns 2 if there are two matches" do
          card = Day04::ScratchOffCard.new(winning_numbers: [1, 2, 3], played_numbers: [1, 2, 5])
          expect(card.score).to eq 2
        end

        it "returns 4 if there are three matches" do
          card = Day04::ScratchOffCard.new(winning_numbers: [1, 2, 3], played_numbers: [1, 2, 3])
          expect(card.score).to eq 4
        end

        it "returns 8 if there are four matches" do
          card = Day04::ScratchOffCard.new(winning_numbers: [1, 2, 3, 4, 5], played_numbers: [1, 2, 3, 4, 9])
          expect(card.score).to eq 8
        end

        it "returns 0 if there are no matches" do
          card = Day04::ScratchOffCard.new(winning_numbers: [1, 2, 3], played_numbers: [4, 5, 6])
          expect(card.score).to eq 0
        end
      end
    end
    context "initialization" do
      it "can be created from a string" do
        card = Day04::ScratchOffCard.from_string("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
        expect(card.card_number).to eq 1
        expect(card.winning_numbers).to eq [41, 48, 83, 86, 17]
        expect(card.played_numbers).to eq [83, 86, 6, 31, 17, 9, 48, 53]
      end
    end
  end

  describe Day04::ScratchOffGame do
    context "properties" do
      it "has a set of cards" do
        game = Day04::ScratchOffGame.new(cards: [
          Day04::ScratchOffCard.new(card_number: 1, winning_numbers: [1, 2, 3], played_numbers: [1, 4, 5]),
          Day04::ScratchOffCard.new(card_number: 2, winning_numbers: [1, 2, 3], played_numbers: [4, 5, 6])
        ])
        expect(game.cards.size).to eq 2
      end
    end

    describe "#all_cards" do
      it "returns the the original cards with the copies that have been won" do
        card_1 = Day04::ScratchOffCard.new(card_number: 1, winning_numbers: [1, 2, 3], played_numbers: [1, 4, 5])
        card_2 = Day04::ScratchOffCard.new(card_number: 2, winning_numbers: [1, 2, 3], played_numbers: [4, 5, 6])
        game = Day04::ScratchOffGame.new(cards: [
          card_1,
          card_2
        ])

        expect(game.all_cards).to match_array([
          card_1,
          card_2,
          card_2
        ])
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/04.txt", chomp: true)
      expect(Day04.part_one(input)).to eq 13
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/04.txt", chomp: true)
      expect(Day04.part_two(input)).to eq 30
    end
  end
end
