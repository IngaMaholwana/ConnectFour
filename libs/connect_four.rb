# frozen_string_literal: true

# A class to model the game Connect Four
class Game
  attr_accessor :board, :winner

  def initialize(player_one = "\u{1F535}", player_two = "\u{1F534}")
    @player_one = player_one
    @player_two = player_two
    @current_player = player_one
    @board = [[nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil]]
    @winner = nil
    @winning_combinations_horizontal = [[0, 1, 2, 3],
                                        [1, 2, 3, 4],
                                        [2, 3, 4, 5],
                                        [3, 4, 5, 6]]

    @winning_combinations_vertical = [[0, 1, 2, 3],
                                      [1, 2, 3, 4],
                                      [2, 3, 4, 5]]

    @d = [[[2, 3, 4, 5], [0, 1, 2, 3]],
          [[1, 2, 3, 4], [0, 1, 2, 3]],
          [[2, 3, 4, 5], [1, 2, 3, 4]],
          [[0, 1, 2, 3], [0, 1, 2, 3]],
          [[1, 2, 3, 4], [1, 2, 3, 4]],
          [[2, 3, 4, 5], [2, 3, 4, 5]],
          [[0, 1, 2, 3], [1, 2, 3, 4]],
          [[1, 2, 3, 4], [2, 3, 4, 5]],
          [[2, 3, 4, 5], [3, 4, 5, 6]],
          [[0, 1, 2, 3], [2, 3, 4, 5]],
          [[1, 2, 3, 4], [3, 4, 5, 6]],
          [[0, 1, 2, 3], [3, 4, 5, 6]],
          [[5, 4, 3, 2], [3, 4, 5, 6]],
          [[5, 4, 3, 2], [2, 3, 4, 5]],
          [[4, 3, 2, 1], [3, 4, 5, 6]],
          [[5, 4, 3, 2], [1, 2, 3, 4]],
          [[4, 3, 2, 1], [2, 3, 4, 5]],
          [[3, 2, 1, 0], [3, 4, 5, 6]],
          [[5, 4, 3, 2], [0, 1, 2, 3]],
          [[4, 3, 2, 1], [1, 2, 3, 4]],
          [[3, 2, 1, 0], [2, 3, 4, 5]],
          [[4, 3, 2, 1], [0, 1, 2, 3]],
          [[3, 2, 1, 0], [1, 2, 3, 4]],
          [[3, 2, 1, 0], [0, 1, 2, 3]]]
  end

  def win_rows
    @board.each do |row|
      @winning_combinations_horizontal.each do |combo|
        mapped = []
        combo.each do |idx|
          mapped << row[idx]
        end
        return true if mapped.all?(mapped[0]) && !mapped[0].nil?
      end
    end
    false
  end

  def win_verticals
    7.times do |horizontal_index|
      [[0, 1, 2, 3], [1, 2, 3, 4], [2, 3, 4, 5]].each do |combo|
        win = []
        combo.each do |vertical_index|
          win << @board[vertical_index][horizontal_index]
        end
        return true if win.all?(win[0]) && !win[0].nil?
      end
    end
    false
  end

  def win_diagonal
    @d.each do |value|
      row = value[0]
      index = value[1]
      win = []
      row.length.times do |t|
        win << @board[row[t]][index[t]]
      end
      return true if win.all?(win[0]) && !win[0].nil?
    end
    false
  end

  def win_exists
    win_rows || win_verticals || win_diagonal
  end

  def end_game
    show_board
    if @winner
      puts "Player #{@winner} wins!"
    else
      puts 'Nobody wins. This game ended in a tie :('
    end
  end

  def update_board(horizontal, vertical)
    @board[horizontal][vertical] = @current_player
  end

  def available_moves
    moves = []
    @board.each_with_index do |row, vertical_index|
      row.each_with_index do |spot, horizontal_index|
        if spot.nil?
          if vertical_index == 5
            moves << [vertical_index, horizontal_index]
          elsif !@board[vertical_index + 1][horizontal_index].nil?
            moves << [vertical_index,
                      horizontal_index]
          end
        end
      end
    end
    moves
  end

  def player_move
    puts 'Please Select A Move: '
    move = gets.chomp.split(',').map(&:to_i)
    moves = available_moves
    return move if moves.include?(move)

    player_move
  end

  def update_game
    if win_exists
      @winner = @current_player
    else
      @current_player = @current_player == @player_one ? @player_two : @player_one
    end
  end

  def show_board
    @board.each do |row|
      p row
    end
  end

  def play_round
    show_board
    move = player_move
    update_board(move[0], move[1])
    update_game
  end

  def board_full
    @board.each do |row|
      row.each do |el|
        return false if el.nil?
      end
    end
    true
  end

  def play_game
    play_round until board_full || !@winner.nil?
    end_game
  end
end