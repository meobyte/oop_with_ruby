class Player
  def initialize
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Dealer
  def initialize
  end

  def deal
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Participant
end

class Deck
  attr_accessor :cards

  def initialize
    @cards []
    Card::SUITS.each do |suit|
      Card::RANKS.each { |rank| @cards << Card.new(suit, rank) }
    end
    mix!
  end

  def mix!
    cards.shuffle!
  end

  def deal
    cards.pop
  end
end

class Card
  attr_accessor :suit, :rank
  SUITS = ['C', 'D', 'H', 'S']
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def find_suit
    case suit
    when "C" then "\u2663"
    when "D" then "\u2666"
    when "H" then "\u2665"
    when "S" then "\u2660"
    end
  end

  def to_s
    "#{rank} #{find_suit}".rjust(4) + " |"
  end
end

class Game
  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start

