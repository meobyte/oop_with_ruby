class Card
  attr_accessor :suit, :rank
  SUITS = ['C', 'D', 'H', 'S']
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def suit
    case @suit
    when 'C' then "\u2663"
    when 'D' then "\u2666"
    when 'H' then "\u2665"
    when 'S' then "\u2660"
    end
  end

  def to_s
    "#{rank} #{find_suit}".rjust(4) + " |"
  end
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

module Hand
  def show_hand
    hand = "|"
    cards.each {|card| hand += card.to_s}
    puts "#{name.rjust(10)}: #{hand}"
  end

  def show_final_hand
    show_hand
    puts "Total: #{total}"
  end

  def total
    ranks = cards.map { |card| card.rank }
    aces_count = ranks.count { |rank| rank == "A"}
    total = 0

    ranks.each do |rank|
      if rank == "A"
        total += 11
      else
        total += (rank.to_i == 0 ? 10 : rank.to_i)
      end
    end

    aces_count.times { total -= 10 if total > 21 }

    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > 21
  end
end

class Participant
  include Hand

  attr_accessor :name, :cards
  def initialize
    @cards = []
    set_name
  end
end

class Player < Participant
  def set_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, must enter a value."
    end
    self.name = name
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

