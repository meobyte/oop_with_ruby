require 'pry'
class Board
  WINS = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
          [1, 4, 7], [2, 5, 8], [3, 6, 9],
          [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.select { |_, sq| sq.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINS.each do |line|
      squares = @squares.values_at(*line)
      if three_in_a_row?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def draw
    puts <<-eos
       |     |
    #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}
       |     |
  -----+-----+-----
       |     |
    #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}
       |     |
  -----+-----+-----
       |     |
    #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}
       |     |
    eos
  end

  private

  def three_in_a_row?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  attr_accessor :marker
  INITIAL_MARKER = ' '

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :score
  attr_reader :marker

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class Human < Player
  def move(board)
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = marker
  end

  def joinor(array, delimiter = ', ', word = 'or')
    array[-1] = "#{word} #{array.last}" if array.size > 1
    array.join(delimiter)
  end
end

class Computer < Player
  def move(board)
    board[best_move(board)] = marker
  end

  def random_move(board)
    board[board.unmarked_keys.sample] = marker
  end

  def best_move(board, depth=0, score={})
    return 0 if board.full?
    return -1 if board.someone_won?

    board.unmarked_keys.each do |space|
      board[space] = board.unmarked_keys.size.even? ? 'O' : 'X'
      score[space] = -1 * best_move(board, depth + 1, {})
      board[space] = ' '
    end

    if depth == 0
      return score.max_by { |_, value| value }[0]
    else
      return score.max_by { |_, value| value }[1]
    end
  end
end

class TTTGame
  attr_reader :board, :human, :computer
  X_MARKER = 'X'
  O_MARKER = 'O'
  FIRST_TO_MOVE = X_MARKER

  def initialize
    @board = Board.new
    @human = Human.new(X_MARKER)
    @computer = Computer.new(O_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message

    loop do
      display_board
      take_turns
      keep_score
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
    puts ''
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end

  def display_goodbye_message
    if human.score == 5
      puts "You won the game!"
    elsif computer.score == 5
      puts "Computer won the game!"
    end
    puts 'Thanks for playing! Goodbye!'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You are #{human.marker}. Computer is #{computer.marker}."
    puts ''
    board.draw
    puts ''
  end

  def current_player_moves
    if @current_marker == X_MARKER
      human.move(board)
      @current_marker = O_MARKER
    else
      computer.move(board)
      @current_marker = X_MARKER
    end
  end

  def take_turns
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def keep_score
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts 'You won this round!'
    when computer.marker
      puts 'Computer won this round!'
    else
      puts "It's a tie!"
    end
    puts "You: #{human.score}; Computer: #{computer.score}"
  end

  def play_again?
    return false if human.score == 5 || computer.score == 5
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts 'Sorry, must by y or n'
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end
end

game = TTTGame.new
game.play
