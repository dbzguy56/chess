require 'colorize'

$chess_pieces = {:k => "\u265a", :q => "\u265b", :r => "\u265c", :b => "\u265d", :n => "\u265e", :p => "\u265f"}
$game_grid = []
$background_color = []

class ChessPiece
  attr_accessor :value, :color, :turn
  def initialize value, row
    @turn = 0
    if row < 2
      @color = "Red"
    else
      @color = "Blue"
    end
    @value = value
  end
end

#this initializes game_grid and background_color
odd = true
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
    $game_grid.push(0)#value_to_push)
    if odd
      $background_color.push(1)
    else
      $background_color.push(0)
    end
    odd = !odd
  end
  odd = !odd
end
$game_grid[18] = ChessPiece.new($chess_pieces[:k],4)
$game_grid[50] = ChessPiece.new($chess_pieces[:r],0)
$game_grid[60] = ChessPiece.new($chess_pieces[:k],0)

def reset_background
  odd = true
  8.times do |y|
    8.times do |x|
      pos = y * 8 + x
      if odd
        $background_color[pos] = 1
      else
        $background_color[pos] = 0
      end
      odd = !odd
    end
    odd = !odd
  end
end

def print_game_board
  puts
  puts "  a b c d e f g h"
  8.times do |i|
    print "#{i} "
    8.times do |j|
      pos = i * 8 + j
      piece = $game_grid[pos]
      if piece == 0
        s = " "
      else
        s = piece.value
        if piece.color == "Red"
          s = s.red
        else
          s = s.blue
        end
      end
      back_color = $background_color[pos]
      if back_color == 0
        print s.on_black + " ".on_black
      elsif back_color == 1
        print s.on_white + " ".on_white
      else
        print s.on_yellow + " ".on_yellow
      end
    end
    print " #{i}"
    puts
  end
  puts "  a b c d e f g h"
end

def get_col letter
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
end

def get_letter col
  case col
    when 0
      letter = "A"
    when 1
      letter = "B"
    when 2
      letter = "C"
    when 3
      letter = "D"
    when 4
      letter = "E"
    when 5
      letter = "F"
    when 6
      letter = "G"
    when 7
      letter = "H"
    end
end

def valid_square
  valid = true
  input = gets.chomp
  check_valid = /\A[0-7][a-hA-H]\z/.match(input)

  if check_valid == nil
    valid = false
  else
    row = input[0].to_i
    letter = input[1].upcase!
  end

  if valid
    col = get_col(letter)
    pos = row * 8 + col
  else
    pos = nil
  end
end

blue_turn = true
winner = false

while(!winner)
  system "clear"
  reset_background
  print_game_board
  if blue_turn
    turn_string = "Blue".blue
    team_turn = "Blue"
  else
    turn_string = "Red".red
    team_turn = "Red"
  end

  puts "#{turn_string}, it is your turn!"

  #find index of king
  $game_grid.each_with_index do |x, index|
    if x != 0 && x.value == $chess_pieces[:k] && x.color == team_turn
      king_index = index
      break
    end
  end
  #check
  check_up = true
  check_down = true
  check_left = true
  check_right = true
  check_top_right = true
  check_top_left = true
  check_bot_right = true
  check_bot_left = true
  current_down = king_index
  current_up = king_index
  current_left = king_index
  current_right = king_index
  current_top_left = king_index
  current_top_right = king_index
  current_bot_left = king_index
  current_bot_right = king_index

  #checks each side of king and sees if there is a piece that it can be doomed by
  while (check_down)
    if check_down
      current_down = current_down + 8
      if (current_down > 63)
        check_down = false
      end
    end
  end

  puts "Choose a piece to move by typing a number followed by a letter (eg. 3A)"
  piece_pos = valid_square
  if piece_pos != nil && (($game_grid[piece_pos] == 0) || (blue_turn && $game_grid[piece_pos].color != "Blue") || (!blue_turn && $game_grid[piece_pos].color != "Red"))
    puts "You cannot move that piece because it is not the color #{turn_string}!"
    piece_pos = nil
  end
  if piece_pos == nil
    puts "\nThat is not a valid input. Press the Enter key to try again."
    gets
  else
    if blue_turn
      negative_multiplier = 1
    else
      negative_multiplier = -1
    end

    piece = $game_grid[piece_pos]
    value_of_selected = piece.value
    possible_moves = false
    case value_of_selected
    when $chess_pieces[:p] #pawn
      #one move ahead of pawn
      if $game_grid[piece_pos-(8*negative_multiplier)] == 0
        $background_color[piece_pos-(8*negative_multiplier)] = 2
        possible_moves = true
      end

      if $game_grid[piece_pos-(7*negative_multiplier)] != 0 && $game_grid[piece_pos-(7*negative_multiplier)].color != piece.color
        $background_color[piece_pos-(7*negative_multiplier)] = 2
        possible_moves = true
      elsif $game_grid[piece_pos-(9*negative_multiplier)] != 0 && $game_grid[piece_pos-(9*negative_multiplier)].color != piece.color
        $background_color[piece_pos-(9*negative_multiplier)] = 2
        possible_moves = true
      end
      if piece.turn == 0 && $game_grid[piece_pos-(16*negative_multiplier)] == 0
        $background_color[piece_pos-(16*negative_multiplier)] = 2
        possible_moves = true
      end
    when $chess_pieces[:n] #knight
      knight_moves_arr = [6, 15, 10, 17]
      a = piece_pos / 8
      b = piece_pos - knight_moves_arr[0]
      c = piece_pos + knight_moves_arr[0]
      d = piece_pos - knight_moves_arr[3]
      e = piece_pos + knight_moves_arr[3]
      f = piece_pos - knight_moves_arr[1]
      g = piece_pos + knight_moves_arr[1]
      h = piece_pos - knight_moves_arr[2]
      i = piece_pos + knight_moves_arr[2]
      if piece_pos > 5 &&  (a != (b / 8)) && ($game_grid[b] == 0 || $game_grid[b].color != piece.color)
        $background_color[b] = 2
        possible_moves = true
      end
      if piece_pos > 14 && (a - (f / 8)) == 2 && ($game_grid[f] == 0 || $game_grid[f].color != piece.color)
        $background_color[f] = 2
        possible_moves = true
      end
      if piece_pos > 9 && (a - (h / 8)) == 1 && ($game_grid[h] == 0 || $game_grid[h].color != piece.color)
        $background_color[h] = 2
        possible_moves = true
      end
      if piece_pos > 16 && (a - (d / 8)) == 2 && ($game_grid[d] == 0 || $game_grid[d].color != piece.color)
        $background_color[d] = 2
        possible_moves = true
      end
      if piece_pos < 58 && (a != (c / 8)) && ($game_grid[c] == 0 || $game_grid[c].color != piece.color)
        $background_color[c] = 2
        possible_moves = true
      end
      if piece_pos < 49 && ((g / 8) - a) == 2 && ($game_grid[g] == 0 || $game_grid[g].color != piece.color)
        $background_color[g] = 2
        possible_moves = true
      end
      if piece_pos < 54 && ((i / 8) - a) == 1 && ($game_grid[i] == 0 || $game_grid[i].color != piece.color)
        $background_color[i] = 2
        possible_moves = true
      end
      if piece_pos < 47 && ((e / 8) - a) == 2 && ($game_grid[e] == 0 || $game_grid[e].color != piece.color)
        $background_color[e] = 2
        possible_moves = true
      end
    when $chess_pieces[:r] #rook
      up = true
      down = true
      right = true
      left = true
      current_up_pos = piece_pos
      current_down_pos = piece_pos
      current_left_pos = piece_pos
      current_right_pos = piece_pos
      while(up || down || left || right)
        if up
          current_up_pos = current_up_pos - 8
          if (current_up_pos < 0)
            up = false
          elsif $game_grid[current_up_pos] != 0
            if $game_grid[current_up_pos].color != piece.color
              $background_color[current_up_pos] = 2
              possible_moves = true
            end
            up = false
          else
            $background_color[current_up_pos] = 2
            possible_moves = true
          end
        end
        if down
          current_down_pos = current_down_pos + 8
          if (current_down_pos > 63)
            down = false
          elsif $game_grid[current_down_pos] != 0
            if $game_grid[current_down_pos].color != piece.color
              $background_color[current_down_pos] = 2
              possible_moves = true
            end
            down = false
          else
            $background_color[current_down_pos] = 2
            possible_moves = true
          end
        end
        if left
          current_left_pos = current_left_pos - 1
          if (current_left_pos / 8) != (piece_pos / 8)
            left = false
          elsif $game_grid[current_left_pos] != 0
            if $game_grid[current_left_pos].color != piece.color
              $background_color[current_left_pos] = 2
              possible_moves = true
            end
            left = false
          else
            $background_color[current_left_pos] = 2
            possible_moves = true
          end
        end
        if right
          current_right_pos = current_right_pos + 1
          if (current_right_pos / 8) != (piece_pos / 8)
            right = false
          elsif $game_grid[current_right_pos] != 0
            if $game_grid[current_right_pos].color != piece.color
              $background_color[current_right_pos] = 2
              possible_moves = true
            end
            right = false
          else
            $background_color[current_right_pos] = 2
            possible_moves = true
          end
        end
      end
    when $chess_pieces[:b] #bishop
      l_up = true
      l_down = true
      r_up = true
      r_down = true
      current_lup_pos = piece_pos
      current_ldown_pos = piece_pos
      current_rup_pos = piece_pos
      current_rdown_pos = piece_pos
      while(l_up || l_down || r_up || r_down)
        if l_up
          last_lup_pos = current_lup_pos
          current_lup_pos = current_lup_pos - 9
          if (current_lup_pos < 0 || ((last_lup_pos / 8)-(current_lup_pos / 8)) != 1)
            l_up = false
          elsif $game_grid[current_lup_pos] != 0
            if $game_grid[current_lup_pos].color != piece.color
              $background_color[current_lup_pos] = 2
              possible_moves = true
            end
            l_up = false
          else
            $background_color[current_lup_pos] = 2
            possible_moves = true
          end
        end

        if l_down
          last_ldown_pos = current_ldown_pos
          current_ldown_pos = current_ldown_pos + 7
          if (current_ldown_pos > 63 || ((current_ldown_pos / 8) - (last_ldown_pos / 8)) != 1)
            l_down = false
          elsif $game_grid[current_ldown_pos] != 0
            if $game_grid[current_ldown_pos].color != piece.color
              $background_color[current_ldown_pos] = 2
              possible_moves = true
            end
            l_down = false
          else
            $background_color[current_ldown_pos] = 2
            possible_moves = true
          end
        end
        if r_up
          last_rup_pos = current_rup_pos
          current_rup_pos = current_rup_pos - 7
          if (current_rup_pos < 0 || ((last_rup_pos / 8)- (current_rup_pos / 8)) != 1)
            r_up = false
          elsif $game_grid[current_rup_pos] != 0
            if $game_grid[current_rup_pos].color != piece.color
              $background_color[current_rup_pos] = 2
              possible_moves = true
            end
            r_up = false
          else
            $background_color[current_rup_pos] = 2
            possible_moves = true
          end
        end
        if r_down
          last_rdown_pos = current_rdown_pos
          current_rdown_pos = current_rdown_pos + 9
          if (current_rdown_pos > 63 || ((current_rdown_pos / 8) - (last_rdown_pos / 8)) != 1)
            r_down = false
          elsif $game_grid[current_rdown_pos] != 0
            if $game_grid[current_rdown_pos].color != piece.color
              $background_color[current_rdown_pos] = 2
              possible_moves = true
            end
            r_down = false
          else
            $background_color[current_rdown_pos] = 2
            possible_moves = true
          end
        end
      end
    when $chess_pieces[:q] #queen
      up = true
      down = true
      right = true
      left = true
      current_up_pos = piece_pos
      current_down_pos = piece_pos
      current_left_pos = piece_pos
      current_right_pos = piece_pos
      while(up || down || left || right)
        if up
          current_up_pos = current_up_pos - 8
          if (current_up_pos < 0)
            up = false
          elsif $game_grid[current_up_pos] != 0
            if $game_grid[current_up_pos].color != piece.color
              $background_color[current_up_pos] = 2
              possible_moves = true
            end
            up = false
          else
            $background_color[current_up_pos] = 2
            possible_moves = true
          end
        end
        if down
          current_down_pos = current_down_pos + 8
          if (current_down_pos > 63)
            down = false
          elsif $game_grid[current_down_pos] != 0
            if $game_grid[current_down_pos].color != piece.color
              $background_color[current_down_pos] = 2
              possible_moves = true
            end
            down = false
          else
            $background_color[current_down_pos] = 2
            possible_moves = true
          end
        end
        if left
          current_left_pos = current_left_pos - 1
          if (current_left_pos / 8) != (piece_pos / 8)
            left = false
          elsif $game_grid[current_left_pos] != 0
            if $game_grid[current_left_pos].color != piece.color
              $background_color[current_left_pos] = 2
              possible_moves = true
            end
            left = false
          else
            $background_color[current_left_pos] = 2
            possible_moves = true
          end
        end
        if right
          current_right_pos = current_right_pos + 1
          if (current_right_pos / 8) != (piece_pos / 8)
            right = false
          elsif $game_grid[current_right_pos] != 0
            if $game_grid[current_right_pos].color != piece.color
              $background_color[current_right_pos] = 2
              possible_moves = true
            end
            right = false
          else
            $background_color[current_right_pos] = 2
            possible_moves = true
          end
        end
      end

      l_up = true
      l_down = true
      r_up = true
      r_down = true
      current_lup_pos = piece_pos
      current_ldown_pos = piece_pos
      current_rup_pos = piece_pos
      current_rdown_pos = piece_pos
      while(l_up || l_down || r_up || r_down)
        if l_up
          last_lup_pos = current_lup_pos
          current_lup_pos = current_lup_pos - 9
          if (current_lup_pos < 0 || ((last_lup_pos / 8)-(current_lup_pos / 8)) != 1)
            l_up = false
          elsif $game_grid[current_lup_pos] != 0
            if $game_grid[current_lup_pos].color != piece.color
              $background_color[current_lup_pos] = 2
              possible_moves = true
            end
            l_up = false
          else
            $background_color[current_lup_pos] = 2
            possible_moves = true
          end
        end

        if l_down
          last_ldown_pos = current_ldown_pos
          current_ldown_pos = current_ldown_pos + 7
          if (current_ldown_pos > 63 || ((current_ldown_pos / 8) - (last_ldown_pos / 8)) != 1)
            l_down = false
          elsif $game_grid[current_ldown_pos] != 0
            if $game_grid[current_ldown_pos].color != piece.color
              $background_color[current_ldown_pos] = 2
              possible_moves = true
            end
            l_down = false
          else
            $background_color[current_ldown_pos] = 2
            possible_moves = true
          end
        end
        if r_up
          last_rup_pos = current_rup_pos
          current_rup_pos = current_rup_pos - 7
          if (current_rup_pos < 0 || ((last_rup_pos / 8)- (current_rup_pos / 8)) != 1)
            r_up = false
          elsif $game_grid[current_rup_pos] != 0
            if $game_grid[current_rup_pos].color != piece.color
              $background_color[current_rup_pos] = 2
              possible_moves = true
            end
            r_up = false
          else
            $background_color[current_rup_pos] = 2
            possible_moves = true
          end
        end
        if r_down
          last_rdown_pos = current_rdown_pos
          current_rdown_pos = current_rdown_pos + 9
          if (current_rdown_pos > 63 || ((current_rdown_pos / 8) - (last_rdown_pos / 8)) != 1)
            r_down = false
          elsif $game_grid[current_rdown_pos] != 0
            if $game_grid[current_rdown_pos].color != piece.color
              $background_color[current_rdown_pos] = 2
              possible_moves = true
            end
            r_down = false
          else
            $background_color[current_rdown_pos] = 2
            possible_moves = true
          end
        end
      end
    when $chess_pieces[:k] #king
      #above
      current_up_pos = piece_pos - 8
      if (current_up_pos >= 0) && ($game_grid[current_up_pos] == 0 || $game_grid[current_up_pos].color != piece.color)
        $background_color[current_up_pos] = 2
        possible_moves = true
      end
      #below
      current_down_pos = piece_pos + 8
      if (current_down_pos < 64) && ($game_grid[current_down_pos] == 0 || $game_grid[current_down_pos].color != piece.color)
        $background_color[current_down_pos] = 2
        possible_moves = true
      end
      #left
      current_left_pos = piece_pos - 1
      if (current_left_pos / 8 == piece_pos / 8) && ($game_grid[current_left_pos] == 0 || $game_grid[current_left_pos].color != piece.color)
        $background_color[current_left_pos] = 2
        possible_moves = true
      end
      #right
      current_right_pos = piece_pos + 1
      if (current_right_pos / 8 == piece_pos / 8) && ($game_grid[current_right_pos] == 0 || $game_grid[current_right_pos].color != piece.color)
        $background_color[current_right_pos] = 2
        possible_moves = true
      end
      #top left
      current_lup_pos = piece_pos - 9
      if current_lup_pos >= 0 && ((piece_pos / 8)-(current_lup_pos / 8)) == 1 && ($game_grid[current_lup_pos] == 0 || $game_grid[current_lup_pos].color != piece.color)
        $background_color[current_lup_pos] = 2
        possible_moves = true
      end
      #bottom left
      current_ldown_pos = piece_pos + 7
      if current_ldown_pos < 64 && ((current_ldown_pos / 8) - (piece_pos / 8)) == 1 && ($game_grid[current_ldown_pos] == 0 || $game_grid[current_ldown_pos].color != piece.color)
        $background_color[current_ldown_pos] = 2
        possible_moves = true
      end
      #top right
      current_rup_pos = piece_pos - 7
      if current_rup_pos >= 0 && ((piece_pos / 8) - (current_rup_pos / 8)) == 1 && ($game_grid[current_rup_pos] == 0 || $game_grid[current_rup_pos].color != piece.color)
        $background_color[current_rup_pos] = 2
        possible_moves = true
      end
      #bottom right
      current_rdown_pos = piece_pos + 9
      if current_rdown_pos < 64 && ((current_rdown_pos / 8) - (piece_pos / 8)) == 1 && ($game_grid[current_rdown_pos] == 0 || $game_grid[current_rdown_pos].color != piece.color )
        $background_color[current_rdown_pos] = 2
        possible_moves = true
      end
    end

    if possible_moves
      system "clear"
      print_game_board
      puts "\n#{turn_string}, you have chosen the piece: #{piece_pos/8}#{get_letter(piece_pos%8)}\nChoose a square to move the piece to by typing a number followed by a letter: "
      move_pos = valid_square
    else
      puts "\nThe piece you have chosen does not have any possible moves! Choose another piece"
      move_pos = nil
    end
    if move_pos != nil
      if $game_grid[move_pos] != 0 && ($game_grid[piece_pos].color == $game_grid[move_pos].color)
        puts "You cannot move your piece onto another one of your pieces!"
        move_pos = nil
      end
      if move_pos != nil && $background_color[move_pos] != 2
        puts "That is not a valid place to move with your chess piece!"
        move_pos = nil
      end
    end

    if move_pos == nil
      puts "\nThat is not a valid input. Press the Enter key to try again."
      gets
    else #moves the chess piece
      piece.turn += 1
      temp = $game_grid[piece_pos]
      if $game_grid[move_pos] == 0
        $game_grid[piece_pos] = $game_grid[move_pos]
      else
        $game_grid[piece_pos] = 0
      end
      $game_grid[move_pos] = temp

      if value_of_selected == $chess_pieces[:p]
        if blue_turn && (move_pos / 8) == 0
          $game_grid[move_pos] = ChessPiece.new($chess_pieces[:q], 6)
        elsif !blue_turn && (move_pos / 8) == 7
          $game_grid[move_pos] = ChessPiece.new($chess_pieces[:q], 0)
        end
      end
      blue_turn = !blue_turn
    end
  end

  count_kings = 0
  $game_grid.each do |x|
    if x != 0 && x.value == $chess_pieces[:k]
      count_kings += 1
    end
  end

  if count_kings != 2
    winner = true
    blue_turn = !blue_turn
  end
end

if blue_turn
  puts "Blue".blue + ", you are the winner!"
else
  puts "Red".red + ", you are the winner!"
end
