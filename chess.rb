require 'colorize'

$white_block = " ".on_white
$black_block = " ".on_black
$chess_pieces = {:k => "\u265a", :q => "\u265b", :r => "\u265c", :b => "\u265d", :n => "\u265e", :p => "\u265f"}
$game_grid = []

class ChessPiece
  attr_accessor :value
  def initialize value, row
    if row < 2
      value = value.red
    else
      value = value.blue
    end
    @value = value
  end
end

8.times do |i|
  8.times do |j|
    value_to_push = 0
    if i == 0 || i == 7
      case j
      when 0, 7
        value_to_push = ChessPiece.new($chess_pieces[:r], i)
      when 1, 6
        value_to_push = ChessPiece.new($chess_pieces[:n], i)
      when 2, 5
        value_to_push = ChessPiece.new($chess_pieces[:b], i)
      when 3
        value_to_push = ChessPiece.new($chess_pieces[:q], i)
      when 4
        value_to_push = ChessPiece.new($chess_pieces[:k], i)
      end
    elsif i == 1 || i == 6
      value_to_push = ChessPiece.new($chess_pieces[:p], i)
    end
    $game_grid.push(value_to_push)
  end
end

def print_game_board
  odd = false
  puts
  8.times do |i|
    print "#{i} "
    8.times do |j|
      piece = $game_grid[i * 8 + j]
      if piece == 0
        s = " "
      else
        s = piece.value
      end
      if odd
        print s.on_black + $black_block
      else
        print s.on_white + $white_block
      end
      odd = !odd
    end
    odd = !odd
    puts
  end
  puts "  a b c d e f g h"
end

blue_turn = true
play = true


while(play)
  print_game_board
  if blue_turn
    turn_string = "Blue".blue
  else
    turn_string = "Red".red
  end

  puts "#{turn_string}, it is your turn!"
  puts "Choose a piece to move by typing a number followed by a letter (eg. 3A)"
  begin
    input = gets.chomp.split("")
    row = input[0].to_i
    letter = input[1].upcase!
    if !"ABCDEFGH".include? letter
      letter = 0.upcase
    end
  rescue
    puts "\nThat is not a valid input. Press the Enter key to try again."
    gets
  else
    case letter
    when "A"
      col = 0
    when "B"
      col = 1
    when "C"
      col = 2
    when "D"
      col = 3
    when "E"
      col = 4
    when "F"
      col = 5
    when "G"
      col = 6
    when "H"
      col = 7
    end

    pos = row * 8 + col
    blue_turn = !blue_turn
  end
  system "clear"
end
