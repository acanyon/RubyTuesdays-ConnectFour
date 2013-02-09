require 'spec_helper'

describe Game do
  let(:game) {FactoryGirl.build(:game)}
  let(:column) {(1...Game::NUM_COLUMNS).to_a.sample}
  let(:row) {(1...Game::NUM_ROWS).to_a.sample}
  let(:max_coords) {[(Game::NUM_COLUMNS - 1), (Game::NUM_ROWS - 1)]}
  let(:min_coords) {[0,0]}

  describe 'underlying relationships' do
    let(:game) {Game.new}
    let(:empty_game) {Game.create!.reload}

    it 'should be initialized with an empty board' do
      # create an empty board // array of 7 empty arrays
      empty_board = Array.new(7).map{[]}
      empty_game.board.should =~ empty_board
    end

    it 'should be initialized with status of :in_progress' do
      empty_game.status.should == 'in_progress'
    end

  end

  describe '#make_move' do
    let(:column) {rand((Game::NUM_COLUMNS - 1))}

    before(:each) do
      game.stub(:check_for_winner) {'in_progress'}
    end

    it 'should place a piece on the board' do
      game.should_receive(:set_next_player)
      game.should_receive(:check_for_winner)

      game.board[column].length.should == 0
      game.make_move(column, 'blue')
      game.board[column].length.should == 1
      game.board[column][0].should == 'blue'
    end

    it 'should set the next_player' do
      game.should_receive(:set_next_player)
      game.make_move(column, game.current_player)
    end

    it 'should update the state' do
      game.should_receive(:check_for_winner)
      game.make_move(column, game.current_player)
    end

    describe 'should throw an ArgumentError' do
      let(:game) {FactoryGirl.create(:game)}
      let(:orig_board){game.board.map(&:clone)}

      before(:each) do
        game.changed?.should be_false
      end

      it 'if column is out of bounds' do
        expect {game.make_move(-1, 'red')}.to raise_error(ArgumentError)
        game.board.should =~ orig_board
        game.changed?.should be_false

        expect {game.make_move(Game::NUM_COLUMNS, 'red')}.to raise_error(ArgumentError)
        game.board.should =~ orig_board
        game.changed?.should be_false
      end

      it 'if column is full' do
        game.board[column] = Array.new(Game::NUM_ROWS).map{'red'}

        game.changed?.should be_false
        expect {game.make_move(column, 'blue')}.to raise_error(ArgumentError)
        game.changed?.should be_false
      end

      it 'if player is invalid' do
        game.changed?.should be_false
        expect{game.make_move(column, 'purple')}.to raise_error(ArgumentError)
        game.changed?.should be_false
      end
    end
  end

  describe '#board_position' do
    let(:red_game) {FactoryGirl.build(:game).tap{|game| game.board.map!{ (0...Game::NUM_ROWS).map{'red'}} }}

    it 'should return nil no piece is present' do
      game.board_position(min_coords).should be_nil
      game.board_position(max_coords).should be_nil
      game.board_position([column, row]).should be_nil
    end

    it 'should return player when sampling a full board' do 
      game = red_game
      game.board_position(min_coords).should == 'red'
      game.board_position(max_coords).should == 'red'
      game.board_position([column, row]).should == 'red'
    end

    it 'should return the correct player in a coord' do
      game = red_game
      game.board_position([column, row]).should == 'red'

      game.board[column][row] = 'blue'
      game.board_position([column, row]).should == 'blue'
    end

    it 'should throw an error when coords are out of bounds' do 
      invalid_coords = [ [max_coords[0], max_coords[1] + 1],
                         [max_coords[0] + 1, max_coords[1]],
                         [min_coords[0] - 1, min_coords[1]],
                         [min_coords[0], min_coords[1] - 1] ]

      invalid_coords.each do |coord| 
        expect {game.board_position(coord)}.to raise_error(ArgumentError)
      end
    end
  end

  describe '#coords_valid?' do
    it 'should return true when coord is valid' do
      game.coords_valid?([column, row]).should be_true
    end

    it 'should return false when coord is out of bounds' do
      invalid_coords = [ [max_coords[0], max_coords[1] + 1],
                         [max_coords[0] + 1, max_coords[1]],
                         [min_coords[0] - 1, min_coords[1]],
                         [min_coords[0], min_coords[1] - 1] ]

      invalid_coords.each do |coord|
        game.coords_valid?(coord).should be_false
      end
    end
  end

  describe '#next_player' do
    it 'should return the next player' do
      %w(red blue).each do |player|
        game.current_player = player
        game.next_player.should_not == player
        game.next_player.should == ((player == 'red') ? 'blue' : 'red')
      end
    end
  end

  describe '#set_next_player' do
    let(:player1) { game.current_player }
    let(:player2) {(player1 == 'red') ? 'blue' : 'red'}

    it 'should update the game object with the next player' do
      game.current_player.should == player1
      game.set_next_player
      game.current_player.should == player2
    end

    it 'should return the updated player' do
      game.current_player.should == player1
      game.set_next_player.should == player2
    end
  end

  describe '#check_for_winner' do
    it 'should correctly detect a winner' do
      file = File.open "#{Rails.root}/spec/support/games/game_state.json"
      test_data = file.read
      games = JSON.parse test_data

      games.each do |correct_status, game_data|
        game = Game.create game_data
        game.board = game_data['board']
        puts game.pretty_print
        game.check_for_winner.should == correct_status

 #       game.status.should == correct_status
      end
    end
  end

end
