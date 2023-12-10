module Day07
  class Card
    class << self
      def for(label, include_jokers: false)
        if label.match?(/\d/)
          NumberCard.new(label)
        elsif label.match?(/[TJQKA]/)
          handle_face_card(label, include_jokers)
        else
          raise "Invalid card: #{label}"
        end
      end

      private

      def handle_face_card(label, include_jokers)
        if label == "J" && include_jokers
          Joker.new(label)
        else
          FaceCard.new(label)
        end
      end
    end

    attr_reader :label, :value
    include Comparable

    def initialize(label)
      @label = label
      set_value
    end

    def set_value
      raise NotImplementedError, "Implement in subclass"
    end

    def <=>(other)
      @value <=> other.value
    end

    alias_method :eql?, :==

    def hash
      [@label, @value].hash
    end

    def to_s
      @label
    end
  end

  class NumberCard < Card
    def set_value
      @value = @label.to_i
    end
  end

  class FaceCard < Card
    def set_value
      @value = face_values.fetch(@label) { |key| raise "Invalid face card: #{key}" }
    end

    private

    def face_values
      {
        "T" => 10,
        "J" => 11,
        "Q" => 12,
        "K" => 13,
        "A" => 14
      }
    end
  end

  class Joker < Card
    def set_value
      @value = 0
    end
  end

  class HandFactory
    def initialize(cards)
      @cards = cards
    end

    def hand
      hand_class_for_cards.new(@cards)
    end

    protected

    def hand_class_for_cards
      class_map[counts_of_same_label]
    end

    def counts_of_same_label
      card_tally.values.sort
    end

    def card_tally
      @cards.tally
    end

    def class_map
      {
        [5] => FiveOfAKind,
        [1, 4] => FourOfAKind,
        [2, 3] => FullHouse,
        [1, 1, 3] => ThreeOfAKind,
        [1, 2, 2] => TwoPair,
        [1, 1, 1, 2] => OnePair,
        [1, 1, 1, 1, 1] => HighCard
      }
    end
  end

  class JokerHandFactory < HandFactory
    protected

    def hand_class_for_cards
      return super if number_of_jokers.zero?

      if number_of_jokers > 3
        FiveOfAKind
      else
        joker_lookup.fetch(card_tally_with_jokers_removed, OnePair)
      end
    end

    private

    def number_of_jokers
      @cards.count { |card| card.is_a?(Joker) }
    end

    def joker_lookup
      {
        **single_joker_lookup,
        **two_joker_lookup,
        **three_joker_lookup
      }
    end

    def single_joker_lookup
      {
        [4] => FiveOfAKind,
        [1, 3] => FourOfAKind,
        [2, 2] => FullHouse,
        [1, 1, 2] => ThreeOfAKind
      }
    end

    def two_joker_lookup
      {
        [3] => FiveOfAKind,
        [1, 2] => FourOfAKind,
        [1, 1, 1] => ThreeOfAKind
      }
    end

    def three_joker_lookup
      {
        [2] => FiveOfAKind,
        [1, 1] => FourOfAKind
      }
    end

    def card_tally_with_jokers_removed
      card_tally.reject { |card| card.is_a?(Joker) }.values.sort
    end

    def highest_non_joker_card_count
      card_tally_with_jokers_removed.max
    end
  end

  class Hand
    include Comparable

    attr_reader :cards

    def initialize(cards)
      @cards = cards
    end

    def value
      raise NotImplementedError, "Implement in subclass"
    end

    def <=>(other)
      if value == other.value
        compare_cards(other)
      else
        value <=> other.value
      end
    end

    def to_s
      "#{self.class} (#{@cards.map(&:to_s).join})"
    end

    private

    def compare_cards(other)
      @cards.zip(other.cards) do |card, other_card|
        card_comparison = card <=> other_card
        return card_comparison unless card_comparison.zero?
      end
      0
    end
  end

  class FiveOfAKind < Hand
    def value
      7
    end
  end

  class FourOfAKind < Hand
    def value
      6
    end
  end

  class FullHouse < Hand
    def value
      5
    end
  end

  class ThreeOfAKind < Hand
    def value
      4
    end
  end

  class TwoPair < Hand
    def value
      3
    end
  end

  class OnePair < Hand
    def value
      2
    end
  end

  class HighCard < Hand
    def value
      1
    end
  end

  HandWithBid = Data.define(:hand, :bid)

  class CamelCards
    def initialize(input)
      @hands_with_bids = parse_input(input)
    end

    def total_winnings
      sorted_hands.map.with_index do |hand_with_bid, index|
        hand_with_bid.bid * (index + 1)
      end.sum
    end

    def to_s
      sorted_hands.map(&:hand).map(&:to_s).join("\n")
    end

    private

    def parse_input(input)
      input.map do |line|
        hand, bid = line.split
        HandWithBid.new(parse_hand(hand), bid.to_i)
      end
    end

    def sorted_hands
      @hands_with_bids.sort_by(&:hand)
    end

    protected

    # @param card_string [String]
    def parse_hand(card_string)
      HandFactory.new(card_string.chars.map { |label| Card.for(label) }).hand
    end
  end

  class CamelCardsWithJokers < CamelCards
    protected

    def parse_hand(card_string)
      JokerHandFactory.new(card_string.chars.map { |label| Card.for(label, include_jokers: true) }).hand
    end
  end

  class << self
    def part_one(input)
      camel_cards = CamelCards.new(input)
      camel_cards.total_winnings
    end

    def part_two(input)
      camel_cards = CamelCardsWithJokers.new(input)
      camel_cards.total_winnings
    end
  end
end
