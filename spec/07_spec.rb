require "./07"
RSpec.describe Day07 do
  describe Day07::Card do
    it "has a label" do
      card = Day07::Card.for("A")
      expect(card.label).to eq "A"
    end

    context "comparison" do
      it "considers 2 cards equal if their labels are equal" do
        card1 = Day07::Card.for("A")
        card2 = Day07::Card.for("A")
        expect(card1 == card2).to eq true
      end

      it "compares numbered cards by number" do
        card1 = Day07::Card.for("2")
        expect(card1).to be_a Day07::NumberCard
        expect(card1.value).to eq 2
        card2 = Day07::Card.for("3")
        expect(card2).to be_a Day07::NumberCard
        expect(card2.value).to eq 3
        expect(card1 < card2).to eq true
      end

      it "all numbered cards are less than all lettered cards" do
        card1 = Day07::Card.for("9")
        card2 = Day07::Card.for("A")
        card3 = Day07::Card.for("T")
        expect(card1 < card2).to eq true
        expect(card1 < card3).to eq true
      end

      it "can compare all lettered cards" do
        jack = Day07::Card.for("J")
        ace = Day07::Card.for("A")
        queen = Day07::Card.for("Q")
        king = Day07::Card.for("K")
        ten = Day07::Card.for("T")
        list_of_cards = [
          jack,
          ace,
          queen,
          king,
          ten
        ]
        expect(list_of_cards.sort).to eq [
          ten,
          jack,
          queen,
          king,
          ace
        ]
      end

      it "ranks jokers the lowest" do
        joker = Day07::Joker.new("J")
        face_card = Day07::Card.for("T")
        number_card = Day07::Card.for("2")
        list_of_cards = [
          face_card,
          number_card,
          joker
        ]
        expect(list_of_cards.sort).to eq [
          joker,
          number_card,
          face_card
        ]
      end
    end
  end

  describe Day07::Hand do
    describe "#self.for" do
      it "correctly returns a five of a kind" do
        cards = [
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A")
        ]
        hand = Day07::HandFactory.new(cards).hand
        expect(hand).to be_a Day07::FiveOfAKind
      end

      it "correctly returns a four of a kind" do
        cards = [
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K")
        ]
        hand = Day07::HandFactory.new(cards).hand
        expect(hand).to be_a Day07::FourOfAKind
      end

      it "correctly returns a full house" do
        cards = [
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("K")
        ]
        hand = Day07::HandFactory.new(cards).hand
        expect(hand).to be_a Day07::FullHouse
      end

      it "correctly returns a three of a kind" do
        cards = [
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("Q")
        ]
        hand = Day07::HandFactory.new(cards).hand
        expect(hand).to be_a Day07::ThreeOfAKind
      end

      it "correctly returns a two pair" do
        cards = [
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("K"),
          Day07::Card.for("Q")
        ]
        hand = Day07::HandFactory.new(cards).hand
        expect(hand).to be_a Day07::TwoPair
      end

      it "correctly returns a one pair" do
        cards = [
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("Q"),
          Day07::Card.for("J")
        ]
        hand = Day07::HandFactory.new(cards).hand
        expect(hand).to be_a Day07::OnePair
      end

      it "correctly returns a high card" do
        cards = [
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("Q"),
          Day07::Card.for("J"),
          Day07::Card.for("T")
        ]
        hand = Day07::HandFactory.new(cards).hand
        expect(hand).to be_a Day07::HighCard
      end
    end

    context "comparison" do
      it "ranks the types of hands correctly" do
        five_of_a_kind = Day07::FiveOfAKind.new([
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A")
        ])
        four_of_a_kind = Day07::FourOfAKind.new([
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K")
        ])
        full_house = Day07::FullHouse.new([
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("K")
        ])
        three_of_a_kind = Day07::ThreeOfAKind.new([
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("Q")
        ])
        two_pair = Day07::TwoPair.new([
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("K"),
          Day07::Card.for("Q")
        ])
        one_pair = Day07::OnePair.new([
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("Q"),
          Day07::Card.for("J")
        ])
        high_card = Day07::HighCard.new([
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("Q"),
          Day07::Card.for("J"),
          Day07::Card.for("T")
        ])
        list_of_hands = [
          five_of_a_kind,
          four_of_a_kind,
          full_house,
          three_of_a_kind,
          two_pair,
          one_pair,
          high_card
        ].shuffle

        expect(list_of_hands.sort).to eq [
          high_card,
          one_pair,
          two_pair,
          three_of_a_kind,
          full_house,
          four_of_a_kind,
          five_of_a_kind
        ]
      end
    end
    it "compares hands of the same type correctly" do
      stronger_two_pair = Day07::TwoPair.new([
        Day07::Card.for("K"),
        Day07::Card.for("K"),
        Day07::Card.for("6"),
        Day07::Card.for("7"),
        Day07::Card.for("7")
      ])
      # KTJJT
      weaker_two_pair = Day07::TwoPair.new([
        Day07::Card.for("K"),
        Day07::Card.for("T"),
        Day07::Card.for("J"),
        Day07::Card.for("J"),
        Day07::Card.for("T")
      ])
      list = [stronger_two_pair, weaker_two_pair]
      expect(list.sort).to eq [weaker_two_pair, stronger_two_pair]
    end
  end

  describe Day07::JokerHandFactory do
    it "returns FiveOfAKind for 5 jokers" do
      cards = [
        Day07::Joker.new("J"),
        Day07::Joker.new("J"),
        Day07::Joker.new("J"),
        Day07::Joker.new("J"),
        Day07::Joker.new("J")
      ]
      hand = Day07::JokerHandFactory.new(cards).hand
      expect(hand).to be_a Day07::FiveOfAKind
    end

    it "returns FiveOfAKind for 4 jokers" do
      cards = [
        Day07::Joker.new("J"),
        Day07::Joker.new("J"),
        Day07::Joker.new("J"),
        Day07::Joker.new("J"),
        Day07::Card.for("A")
      ]
      hand = Day07::JokerHandFactory.new(cards).hand
      expect(hand).to be_a Day07::FiveOfAKind
    end
    context "when there are 3 jokers" do
      it "returns FiveOfAKind when the other 2 cards are a pair" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Joker.new("J"),
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("A")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::FiveOfAKind
      end

      it "returns FourOfAKind when the other 2 cards are not a pair" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Joker.new("J"),
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("K")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::FourOfAKind
      end
    end

    context "when there are 2 jokers" do
      it "returns FiveOfAKind when the other 3 cards are the same" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::FiveOfAKind
      end

      it "returns FourOfAKind when the other contain a pair" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::FourOfAKind
      end

      it "returns ThreeOfAKind when all other cards are different" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("Q"),
          Day07::Card.for("K")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::ThreeOfAKind
      end
    end

    context "when there is 1 joker" do
      it "returns FiveOfAKind when the other 4 cards are the same" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::FiveOfAKind
      end

      it "returns FourOfAKind when 3 of the other cards are the same" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::FourOfAKind
      end

      it "returns ThreeOfAKind when 2 of the other cards are the same" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("Q"),
          Day07::Card.for("K")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::ThreeOfAKind
      end

      it "returns FullHouse when the other two cards are pairs" do
        cards = [
          Day07::Joker.new("J"),
          Day07::Card.for("A"),
          Day07::Card.for("A"),
          Day07::Card.for("K"),
          Day07::Card.for("K")
        ]
        hand = Day07::JokerHandFactory.new(cards).hand
        expect(hand).to be_a Day07::FullHouse
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/07.txt", chomp: true)
      expect(Day07.part_one(input)).to eq 6440
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/07.txt", chomp: true)
      expect(Day07.part_two(input)).to eq 5905
    end
  end
end
