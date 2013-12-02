require_relative 'piece'

class Board
  
  DEFAULT_VALUE = nil
    
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(10){ Array.new(10){ DEFAULT_VALUE } }
    populate_board
  end
  
  def move(source, destination) 
    piece = self[source]
    piece.position = destination
    self[destination] = piece
    remove(source)
    true
  end
  
  def remove(pos)
    self[pos] = DEFAULT_VALUE
  end
  
  def [](pos)
    @grid[pos[0]][pos[1]]
  end
  
  def []=(pos, value)
    @grid[pos[0]][pos[1]] = value
  end
  
  def valid_position?(position, color)
    return true if empty?(position)    
    false
  end
  
  def valid_jump?(position)
    return false if out_of_board?(position)
    position if empty?(position)
  end
  
  def out_of_board?(position)
    return false if position.all? do |i|
      i >= 0 && i < 10
    end
    true
  end
  
  def populate_board
    @grid.each_index do |i|
      next if i > 3 && i < 6
      @grid[i].each_index do |j|
        next unless j.even? ^ i.even?
        @grid[i][j] = Piece.new(i, j, self)
      end
    end
  end
  
  def empty?(position)
    self[position].nil?
  end
  
  def to_s
    board = []
    @grid.each_with_index do |row, i|
      row_s = ""
      row.each_with_index do |square, j|
        if square.nil?
          string = "   " 
        else
          string = square.to_s
        end
        
        if j.even? ^ i.even?
          row_s << string
        else
          row_s << string.on_red
        end
      end 
      board << "#{i}|".colorize(:red) + row_s
      
    end
    board << "   0  1  2  3  4  5  6  7  8  9 ".colorize(:red)
  
    board.join("\n")
  end
  
end

board = Board.new
puts board
