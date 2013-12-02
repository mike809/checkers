# encoding: utf-8
require 'colorize'
require 'matrix'

class Piece
  
  TEAM_COLORS = [:white, :yellow]
  
  MOVE_DIR = {
    TEAM_COLORS[1] => [[-1,-1], [-1,1]],
    TEAM_COLORS[0] => [[1,1], [1,-1]]
  }
  
  SYMBOLS = {
    false => { 
      TEAM_COLORS[0] => " ♟ ",
      TEAM_COLORS[1] => " ♟ ",
      :non_solid => " ♙ " 
    },
    true => {
      TEAM_COLORS[0] => " ♚ ",
      TEAM_COLORS[1] => " ♚ ",
      :non_solid => " ♔ " 
    }
  }
  
  attr_accessor :color, :position
  
  def initialize(*pos, board)
    @color = pos.first < 4 ? TEAM_COLORS[0] : TEAM_COLORS[1]
    @position = pos
    @board = board
    @king = false
  end
  
  def same_color?(color)
    self.color == color    
  end
  
  def maybe_promote
    self.king = true if (color == TEAM_COLORS[1] && position.first == 0) ||
                   (color == TEAM_COLORS[0] && position.first == 7)
  end
  
  def perform_slide(destination)
    move(destination)
  end
  
  def move(destination)
    if @board.empty?(destination) && moves.include?(Vector[*destination])
      return @board.move(position, destination)
    end
    false
  end
  
  def perform_jump(path)
    path.each do |destination|
      initial_pos = position
      if move(destination)
        remove_piece( middle(initial_pos, destination))
      else
        return false
      end
    end
    true
  end
  
  def middle(source, destination)
    difference = (Vector[*destination] - Vector[*source])/2
    Vector[*source] + difference
  end
  
  def remove_piece(position)
    @board[position] = Board::DEFAULT_VALUE
  end
  
  def moves
    valid_moves = []
    move_diffs.each do |direction|
      new_pos = Vector[*@position] + Vector[*direction]
      next if @board.out_of_board?(new_pos)  
      
      if @board.valid_position?(new_pos, @color)
        valid_moves << new_pos
      elsif !@board[new_pos].same_color?(@color)
        jump = @board.valid_jump?(new_pos + Vector[*direction])
        valid_moves << jump if jump
      end
    end
    valid_moves
  end
  
  def move_diffs
    return MOVE_DIR.values.inject(:+) if @king
    MOVE_DIR[color]
  end  
    
  def to_s
    if position.first.even? ^ position.last.even?
      return SYMBOLS[self.king][self.color].colorize(self.color)
    else
      return SYMBOLS[self.king][self.color].colorize(self.color).on_red
    end
  end

end