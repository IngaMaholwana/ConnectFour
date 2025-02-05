require_relative './../lib/connect_four'

describe Game do 
  describe '#win_rows' do
    context 'when a round is over, checks if player won on a row' do
      subject(:winner_row) { described_class.new('t', 'j') }

      it 'returns false with no row filled' do
        expect(winner_row.win_rows).to eql(false)
      end

      it 'returns true when one row is filled' do
        winner_row.board[0] = winner_row.board[0][0..3].map { 'x' }
        expect(winner_row.win_rows).to eql(true)
      end
    end
  end

  describe '#win_verticals' do
    context 'when a round is over, check if player won on a vertical' do
      subject(:winner_vertical) { described_class.new('t', 'j') }

      it 'returns false with no vertical win' do
        expect(winner_vertical.win_verticals).to eql(false)
      end

      it 'returns true with vertical win' do
        winner_vertical.board = [[nil, nil, nil, nil, nil, nil, nil],
                                 [nil, nil, nil, nil, nil, nil, nil],
                                 ['x', nil, nil, nil, nil, nil, nil],
                                 ['x', nil, nil, nil, nil, nil, nil],
                                 ['x', nil, nil, nil, nil, nil, nil],
                                 ['x', nil, nil, nil, nil, nil, nil]]

        expect(winner_vertical.win_verticals).to eql(true)
      end
    end
  end

  describe '#win_diagonal' do
    context 'when a round is over, checks if player won a diagonal' do
      subject(:diagonal) { described_class.new('t', 'j') }

      it 'returns false if no diagonal win' do
        expect(diagonal.win_diagonal).to eql(false)
      end

      it 'returns true if diagonal win on board from bottom right' do
        diagonal.board[5][3] = 'x'
        diagonal.board[4][4] = 'x'
        diagonal.board[3][5] = 'x'
        diagonal.board[2][6] = 'x'

        expect(diagonal.win_diagonal).to eql(true)
      end

      it 'returns true if diagonal win on board from top left' do
        diagonal.board[2][0] = 'x'
        diagonal.board[3][1] = 'x'
        diagonal.board[4][2] = 'x'
        diagonal.board[5][3] = 'x'

        expect(diagonal.win_diagonal).to eql(true)
      end
    end
  end

  describe '#win_exists' do
    context 'when a game is over, checks whole board for a win' do
      subject(:winner) { described_class.new('t', 'j') }

      it 'returns false if no win is present' do
        allow(winner).to receive(:win_rows).and_return(false)
        allow(winner).to receive(:win_verticals).and_return(false)
        allow(winner).to receive(:win_diagonal).and_return(false)
        expect(winner.win_exists).to eql(false)
      end

      it 'returns true if vertical win is present' do
        allow(winner).to receive(:win_verticals).and_return(true)
        expect(winner.win_exists).to eql(true)
      end

      it 'returns true if row win is present' do
        allow(winner).to receive(:win_rows).and_return(true)
        expect(winner.win_exists).to eql(true)
      end

      it 'returns true if diagonal win is present' do
        allow(winner).to receive(:win_diagonal).and_return(true)
        expect(winner.win_exists).to eql(true)
      end
    end
  end

  describe '#end_game' do
    context 'when game is over' do
      subject(:winner) { described_class.new('t', 'j') }

      it 'prints an appropriate message to the winner' do
        allow(winner).to receive(:show_board)
        player = 'x'
        winner_message = "Player #{player} wins!\n"
        winner.winner = 'x'
        expect { winner.end_game }.to output(winner_message).to_stdout
      end

      it 'prints an appropriate message for a tie' do
        allow(winner).to receive(:show_board)
        tie_message = "Nobody wins. This game ended in a tie :(\n"
        expect { winner.end_game }.to output(tie_message).to_stdout
      end

      it 'calls show_board once' do
        allow(winner).to receive(:puts)
        expect(winner).to receive(:show_board).once
        winner.end_game
      end
    end
  end

  describe '#update_board' do
    context 'when a player selects a valid move' do
      subject(:game_board) { described_class.new }
      it 'updates the board to reflect the players move' do
        original_board = [[nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil]]

        new_board = [[nil, nil, "\u{1F535}", nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
        move = [0, 2]

        expect { game_board.update_board(move[0], move[1]) }.to change {
          game_board.board
        }.from(original_board).to(new_board)
      end
    end
  end

  describe '#available_moves' do
    context 'when a player selects a move' do
      subject(:available) { described_class.new }

      it 'returns an array' do
        expect(available.available_moves).to be_kind_of Array
      end

      it 'returns the lowest array only when board is empty' do
        expected_output = [[5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6]]
        expect(available.available_moves).to eql(expected_output)
      end

      it 'returns the correct values when lower columns are filled' do
        available.board = [[nil, nil, nil, nil, nil, nil, nil],
                           [nil, nil, nil, nil, nil, nil, nil],
                           [nil, nil, nil, nil, nil, nil, nil],
                           [nil, nil, nil, nil, nil, nil, nil],
                           [nil, nil, nil, nil, nil, nil, nil],
                           ["\u{1F535}", "\u{1F535}", nil, "\u{1F535}", "\u{1F535}", "\u{1F535}", "\u{1F535}"]]
        expected_output = [[4, 0], [4, 1], [4, 3], [4, 4], [4, 5], [4, 6], [5, 2]]

        expect(available.available_moves).to eql(expected_output)
      end
    end
  end

  describe '#player_move' do 
    context 'when a round is initiated, asks current_player for move' do 
      subject(:moves) { described_class.new }

      before do
        allow(moves).to receive(:available_moves).and_return([[0, 2], [0, 3]])
      end

      it 'prompts user to enter move' do
        allow(moves).to receive(:gets).and_return('0, 2')
        move_message = "Please Select A Move: \n"
        expect { moves.player_move }.to output(move_message).to_stdout
      end

      it 'receives input from user' do
        allow(moves).to receive(:puts)
        expect(moves).to receive(:gets).once.and_return('0, 2')
        moves.player_move
      end

      it 'returns an array from the user input' do
        allow(moves).to receive(:puts)
        expect(moves).to receive(:gets).once.and_return('0, 2')
        expect(moves.player_move).to be_kind_of Array
      end

      it 'returns all values in integer form' do
        allow(moves).to receive(:puts)
        expect(moves).to receive(:gets).once.and_return('0, 2')
        expect(moves.player_move).to all be_kind_of Integer
      end

      it 'returns correct value' do
        allow(moves).to receive(:puts)
        expect(moves).to receive(:gets).once.and_return('0, 2')
        expect(moves.player_move).to eql([0, 2])
      end

      it 'calls available_moves once' do
        allow(moves).to receive(:puts)
        allow(moves).to receive(:gets).and_return('0, 2')
        expect(moves).to receive(:available_moves).once
        moves.player_move
      end
    end
  end

  describe '#update_game' do
    context 'when round is over' do
      subject(:round_over) { described_class.new }

      it 'checks for winner' do
        allow(round_over).to receive(:win_exists)
        allow(round_over).to receive(:play_round)
        expect(round_over).to receive(:win_exists).once
        round_over.update_game
      end

      it 'changes player if no winner' do
        allow(round_over).to receive(:win_exists).and_return(false)
        allow(round_over).to receive(:play_round)
        round_over.update_game
        current_player = round_over.instance_variable_get(:@current_player)
        player_two = round_over.instance_variable_get(:@player_two)
        expect(current_player).to eql(player_two)
      end

      it 'updates winner if winner exists' do
        allow(round_over).to receive(:win_exists).and_return(true)
        allow(round_over).to receive(:puts)
        current_player = round_over.instance_variable_get(:@current_player)
        expect { round_over.update_game }.to change(round_over, :winner).from(nil).to(current_player)
      end
    end
  end

  describe '#play_round' do 
    context 'when game is started' do 
      subject(:round) { described_class.new }

      it 'calls show_board once' do
        allow(round).to receive(:player_move).and_return([0, 0])
        allow(round).to receive(:update_board)
        allow(round).to receive(:update_game)
        expect(round).to receive(:show_board).once
        round.play_round
      end

      it 'calls player_move once' do
        allow(round).to receive(:show_board)
        allow(round).to receive(:player_move).and_return([0, 3])
        allow(round).to receive(:update_board)
        allow(round).to receive(:update_game)
        expect(round).to receive(:player_move).once
        round.play_round
      end

      it 'calls update_board once' do
        allow(round).to receive(:show_board)
        allow(round).to receive(:player_move).and_return([0, 2])
        allow(round).to receive(:update_game)
        expect(round).to receive(:update_board).once.with(0, 2)
        round.play_round
      end

      it 'calls update_game once' do
        allow(round).to receive(:show_board)
        allow(round).to receive(:player_move).and_return([0, 2])
        allow(round).to receive(:update_board)
        allow(round).to receive(:update_game)
        expect(round).to receive(:update_game).once
        round.play_round
      end
    end
  end

  describe '#play_game' do 
    context 'when game started' do
      subject(:game) { described_class.new }

      it 'calls play_round when board is not full and winner is nil' do
        allow(game).to receive(:board_full).and_return(false, true)
        allow(game).to receive(:play_round)
        allow(game).to receive(:end_game)
        expect(game).to receive(:play_round).once
        game.play_game
      end

      it 'calls board full' do
        allow(game).to receive(:board_full).and_return(true)
        allow(game).to receive(:end_game)
        expect(game).to receive(:board_full).once
        game.play_game
      end

      it 'calls end_game if board is full' do
        allow(game).to receive(:board_full).and_return(true)
        expect(game).to receive(:end_game).once
        game.play_game
      end

      it 'calls end_game if winner is not nil' do
        allow(game).to receive(:board_full).and_return(false)
        game.winner = game.instance_variable_get(:@player_one)
        expect(game).to receive(:end_game).once
        game.play_game
      end
    end
  end

  describe '#board_full' do
    context 'when round is over' do
      subject(:full) { described_class.new }
      it 'returns true if board is full of non-nil values' do
        full.board = [[1, 2, 3], [4, 5, 6]]
        expect(full.board_full).to eql(true)
      end

      it 'returns false if board contains nil values' do
        expect(full.board_full).to eql(false)
      end
    end
  end
end