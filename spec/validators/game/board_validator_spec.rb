require 'spec_helper'

describe Game::BoardValidator do
  let(:game)        {Game.new}
  let(:max_columns) {Game::NUM_COLUMNS}
  let(:max_rows)    {Game::NUM_ROWS}

  it 'should not allow non-array boards' do
    game.board = {}
    game.valid?.should be_false
  end

  it 'should not allow non-array columns' do
    game.board = [{}]
    game.valid?.should be_false
  end

  it 'should not allow for non-array rows' do
    game.board = Array.new(max_columns).map{ {} }
    game.valid?.should be_false
  end

  it 'should not allow for too many columns' do
    game.board = Array.new(max_columns + 1).map{[]}
    game.valid?.should be_false
  end

  it 'should not allow for too many rows' do
    game.board = Array.new(max_columns).map{[]}
    game.board[0] = Array.new(max_rows + 1)
    game.valid?.should be_false
  end

  it 'should not allow invalid cell elements' do
    game.board = Array.new(max_columns).map{[]}
    game.board[0] << 'red'
    game.board[0] << 'green'
    game.valid?.should be_false
  end

  it 'should allow empty boards' do
    game.board = Array.new(max_columns).map{[]}
    game.valid?.should be_true
  end

  it 'should allow for full boards' do
    game.board = Array.new(max_columns).map do
      Array.new(max_rows).map{%w(red blue).sample}
    end
    game.valid?.should be_true
  end

end
