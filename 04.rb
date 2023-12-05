module Day04
  class ScratchOffCard
    class << self
      def from_string(string)
        card, numbers = string.split(":")
        winning_numbers, played_numbers = numbers.split("|").map do |number_string|
          number_string.split.map(&:to_i)
        end
        card_number = card.split.last.to_i
        new(card_number:, winning_numbers:, played_numbers:)
      end
    end

    attr_reader :card_number, :winning_numbers, :played_numbers

    def initialize(winning_numbers:, played_numbers:, card_number: 1)
      @card_number = card_number
      @winning_numbers = winning_numbers
      @played_numbers = played_numbers
    end

    def ==(other)
      return false unless other.is_a?(ScratchOffCard)
      card_number == other.card_number &&
        winning_numbers == other.winning_numbers &&
        played_numbers == other.played_numbers
    end

    def eql?(other)
      self == other
    end

    def score
      return 0 if matches == 0
      2**(matches - 1)
    end

    def matches
      (@winning_numbers & @played_numbers).size
    end
  end

  class ScratchOffGame
    def initialize(cards:)
      @cards = create_hash_from_cards(cards)
    end

    def cards
      @cards.values
    end

    def all_cards
      @cards.values + cards_won
    end

    private

    def cards_won
      @cards.values.map do |card|
        get_cards_won_from_card(card)
      end.flatten
    end

    def create_hash_from_cards(cards)
      hash = {}
      cards.each do |card|
        hash[card.card_number] = card
      end
      hash
    end

    def get_card_by_number(number)
      @cards[number]
    end

    def get_cards_won_from_card(card)
      return [] if card.matches == 0
      card.matches.times.map do |n|
        next_card_number = card.card_number + n + 1
        card_won = get_card_by_number(next_card_number)
        [card_won, *get_cards_won_from_card(card_won)]
      end
    end
  end

  class << self
    def part_one(input)
      cards = input.map { |line| ScratchOffCard.from_string(line) }
      cards.sum(&:score)
    end

    def part_two(input)
      cards = input.map { |line| ScratchOffCard.from_string(line) }
      game = ScratchOffGame.new(cards: cards)
      game.all_cards.count
    end
  end
end
