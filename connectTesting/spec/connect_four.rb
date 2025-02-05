
describe ConnectFour do
  subject(:game) { described_class.new }

  describe '#insert_token' do
    context 'when player picks a column' do
      it 'should go all the way to the bottom' do
        token = 'white'
        column_input = 1
        column_bottom = -> { game.board[5][column_input - 1] }
        game.insert_token(token, column_input)
        expect(column_bottom.call).to eq(token)
      end
    end
  end
  end