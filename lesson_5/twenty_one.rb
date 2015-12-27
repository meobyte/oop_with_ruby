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
    "#{rank} #{suit}".rjust(4) + " |"
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
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

  def show_flop
    show_hand
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def set_name
    self.name = ROBOTS.sample
  end

  def show_flop
    puts "#{name.rjust(10)}: |\u25A9\u25A9\u25A9\u25A9 |#{cards[1].to_s}\n\n"
  end
end

class TwentyOne
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    deal_cards
    show_flop
    player_turn
    dealer_turn
    show_cards
    if player.busted? || dealer.busted?
      show_busted
    else
      show_result
    end
  end

  private

  def deal_cards
    2.times do
      player.add_card(deck.deal)
      dealer.add_card(deck.deal)
    end
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def show_round
    player.show_hand
    dealer.show_flop
  end

  def show_cards
    player.show_final_hand
    dealer.show_final_hand
  end

  def show_busted
    if player.busted?
      puts "#{player.name} busts! #{dealer.name} wins!"
    elsif dealer.busted?
      puts "#{dealer.name} busts! #{player.name} wins!"
    end
  end

  def show_result
    if player.total > dealer.total
      puts "#{player.name} wins!"
    elsif player.total < dealer.total
      puts "#{dealer.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def player_turn
    loop do
      puts "Would you like to (h)it or (s)tay?"
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if %w(h s).include?(answer)
        puts "Sorry, must enter 'h' or 's'."
      end

      if answer == 's'
        puts "#{player.name} stays."
        break
      elsif player.busted?
        break
      else
        player.add_card(deck.deal)
        puts "#{player.name} hits"
        show_round
        break if player.busted?
      end
    end
  end

  def dealer_turn
    return if player.busted?
    dealer.add_card(deck.deal) until dealer.total >= 17 || dealer.busted?
  end

end

game = TwentyOne.new
game.start

