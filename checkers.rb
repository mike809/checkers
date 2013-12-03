require_relative 'board'

class Game
  
  attr_accessor :board
  
  def initialize
    @board = Board.new
    @player_turn = Piece::TEAM_COLORS
    play
  end

  def play
    turn = 1
    until over?
      begin
        moving_piece_pos = get_input(turn)
        break unless moving_piece_pos
        path = get_input(turn)
        break unless path 
        
        if @board.jump?(path, moving_piece_pos.first)
          @board[moving_piece_pos.first].perform_jump(path, @player_turn[turn])
        else
          @board[moving_piece_pos.first].perform_slide(path[0], @player_turn[turn])
        end
      rescue StandardError => error
        puts error.backtrace.join("\n")
        puts "#{error} Try again."
        retry
        ensure
        turn = (turn + 1) % 2
      end
    end
  end
  
  def over?
    @board.pieces.each do |key, amount_of_pieces|
      return true if amount_of_pieces == 0
    end
    false
  end
  
  def get_input(turn)
    move = []
    while true
      puts @board
      puts "Player #{@player_turn[turn]}  turn."
      
      system("stty raw -echo")
      input = STDIN.getc
      system ('clear')
      system("stty -raw echo")
      
      case input
      when " " then move << @board.cursor.dup
      when "c" then 
        move << @board.cursor.dup
        break
      when "e" then return false
      when "w" then move_cursor(-1,0)
      when "s" then move_cursor(1,0)
      when "d" then move_cursor(0,1)
      when "a" then move_cursor(0,-1)
      end
    end
    move
  end
  
  def move_cursor(*coords)
    @board.cursor.each_index do |i|
      @board.cursor[i] = (@board.cursor[i] + coords[i]) % 10
      @board.cursor[i] = 9 if @board.cursor[i] == -1
    end
  end

end

game = Game.new