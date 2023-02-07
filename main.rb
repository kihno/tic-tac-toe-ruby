class Player
  attr_accessor :name, :score
  attr_reader :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
    @score = 0
  end

  def move(board, location)
    index = location.to_i - 1
    board[index] = @marker
  end
end

class Game
  attr_accessor :board, :gameover, :location

  def initialize
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @gameover = false
    @location = 0
  end

  def start_game
    welcome_message
    choose_player_one
    choose_player_two
    @current_player = @player_one
    display_board
    game_loop
  end

  def new_game
    puts 'Play again? [y/n]'
    answer = gets.chomp

    if answer == 'y'
      @gameover = false
      @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      @current_player = @player_one
      display_board
      game_loop
    elsif answer == 'n'
      display_score
    end
  end

  def welcome_message
    puts 'Welcome to Tic Tac Toe!'
  end

  def choose_player_one
    puts 'Player One, enter name...'
    @player_one = Player.new(gets.chomp, 'X')
  end

  def choose_player_two
    puts 'Player Two, enter name...'
    @player_two = Player.new(gets.chomp, 'O')
  end

  def display_board
    puts "\n
    #{@board[0]} | #{@board[1]} | #{@board[2]}
    --+---+--
    #{@board[3]} | #{@board[4]} | #{@board[5]}
    --+---+--
    #{@board[6]} | #{@board[7]} | #{@board[8]}
    \n"
  end

  def validate_move
    valid = false

    until valid
      if @location == 'exit'
        @gameover = true
        @location = 0
        valid = true
        puts 'Abort!'
      elsif !@location.to_i.between?(1, 9)
        puts 'Invalid location. Please enter a number 1-9'
        @location = gets.chomp
      elsif @board[location.to_i - 1].is_a?(String)
        puts 'This space is taken. Choose another'
        @location = gets.chomp
      else
        valid = true
      end
    end
  end

  def did_win?(marker)
    board[0..2].all? { |value| value == marker } ||
    board[3..5].all? { |value| value == marker } ||
    board[6..9].all? { |value| value == marker } ||
    board.values_at(0, 3 ,6).all? { |value| value == marker } ||
    board.values_at(1, 4 ,7).all? { |value| value == marker } ||
    board.values_at(2, 5 ,8).all? { |value| value == marker } ||
    board.values_at(0, 4 ,8).all? { |value| value == marker } ||
    board.values_at(2, 4 ,6).all? { |value| value == marker }
  end

  def tie_game?
    board.all? { |space| space.is_a?(String) }
  end

  def player_switch
    if @current_player == @player_one
      @current_player = @player_two
    else
      @current_player = @player_one
    end
  end

  def display_score
    puts "#{@player_one.name}: #{@player_one.score}"
    puts "#{@player_two.name}: #{@player_two.score}"
  end

  def game_loop
    until @gameover
      puts "#{@current_player.name}, make your move"
      @location = gets.chomp
      validate_move
      break if @gameover

      @current_player.move(@board, @location)

      if did_win?(@current_player.marker)
        @gameover = true
        @current_player.score += 1
        puts "#{@current_player.name} wins!"
        display_score
        new_game
      elsif tie_game?
        @gameover = true
        display_board
        puts 'Cats Game.'
        display_score
        new_game
      else
        player_switch
        display_board
      end
    end
  end
end

game = Game.new
game.start_game
