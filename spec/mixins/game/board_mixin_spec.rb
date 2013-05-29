require 'spec_helper'

describe Game::BoardMixin do

  describe '.each_board_position' do
    it 'should call block for each board position' do
      @coords = {}

      Game.each_board_position do |coord|
        @coords[coord.to_s] = coord
      end

      @coords.count.should == Game::NUM_ROWS * Game::NUM_COLUMNS
    end
  end

  describe 'direction helpers (.horizontal, .vertical, .diagonal)' do
    let(:column) {(1...Game::NUM_COLUMNS).to_a.sample}
    let(:row) {(1...Game::NUM_ROWS).to_a.sample}

    it 'should return their own coords if distance is 0' do
      coord = [row, column]
      %w(horizontal vertical diagonal_right).map(&:to_s).each do |funct|
        Game.send(funct, coord, 0).should == coord
      end
    end

    it 'should count x away from origin' do
      dist = (Game::NUM_ROWS > Game::NUM_COLUMNS) ? column : row

      coords = %w(horizontal vertical diagonal_right).map(&:to_s).map do |funct|
        Game.send(funct, [0,0], dist)
      end

      coords.should == [[dist,0], [0,dist], [dist, dist]]
    end
  end
end
