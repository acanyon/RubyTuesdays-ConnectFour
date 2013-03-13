class Game < ActiveRecord::Base
  # This includes the methods in mixins/game/board_mixin.rb as class methods.
  # Check this file out for some helpful functions!
  extend Game::BoardMixin
  include Game::BoardMixin

  ### Constants ###

  # These define the size of the board. Remember: we index from 0, so valid
  # board coordinates are between [0,0] to [NUM_COLUMNS - 1 , NUM_ROWS - 1]
  NUM_ROWS = 6
  NUM_COLUMNS = 7

  ### Associations ###
  serialize :board, JSON

  # Security (ActiveModel::MassAssignmentSecurity)
  attr_accessible :board, :created_at, :status, :current_player, :red_player_name, :blue_player_name

  ### Scopes ###
  scope :in_progress, where(:status => :in_progress)
  scope :finished,    where(:status => %w(red blue tie))
  scope :won, where(:status => %w(red blue))
  scope :tie, where(:status => :tie)

  ### Callbacks ###

  ### Validations ###
  validates_inclusion_of :status, :allow_blank => false,
                                  :in => %w(in_progress blue red tie)
  validates_with BoardValidator, :dimensions => [NUM_COLUMNS, NUM_ROWS]
  validates_presence_of [:red_player_name, :blue_player_name], :on => :create


  # Sets current_player to 'blue' iff current_player has not been initialized
  def initialize(*args)
    super(*args)

    # initialize variables
    # NOTE: Add all initialization here!
    self.board = (0...NUM_COLUMNS).map{[]} unless self.board.present?
    self.current_player = 'blue' unless self.current_player.present?
    self.status = 'in_progress' unless self.status.present?
  end

  # Gets the next player
  # @return [String] The next player
  def next_player
    self.current_player == 'red' ? 'blue' : 'red'
  end

  # setNextPlayer sets the next player
  #
  # @return [String] The new player
  def set_next_player
    self.current_player = next_player
  end

  # returns the piece at the coordinates
  def board_position(coords)
    raise ArgumentError, 'those are invalid coordinates' unless coords_valid?(coords)
    board[coords.first][coords.last]
  end

  # checks that the given coordinates are within the valid range
  def coords_valid?(coords)
    raise ArgumentError, 'what dimension are you playing in? wrong # of coords' unless coords.size == 2
    row_in_bounds?(coords.last) and column_in_bounds?(coords.first)
  end

  # MakeMove takes a column and player and updates the board to reflect the
  # given move. Also will update :current_player and :status
  #
  # @param column [Integer]
  # @param player [String] either 'red' or 'blue'
  def make_move(column, player)
    raise ArgumentError, 'column out of bounds' unless column_in_bounds?(column)
    raise ArgumentError, 'column full' unless board[column].size < NUM_ROWS
    raise ArgumentError, 'invalid player' unless %w(blue red).include? player

    board[column] << player
    self.status = check_for_winner
    set_next_player
    self.save
  end

  # Checks if there is a winner and returns the player if it exists
  #
  # @return [String] 'red', 'blue', 'tie', or 'in_progress'
  def check_for_winner

    each_board_position do |coord|
      if check_column(coord) or
            check_row(coord) or
            check_left_diagonal(coord) or
            check_right_diagonal(coord)
        return board_position(coord)
      end
    end

    return 'tie' if board_is_full
    'in_progress'
  end

  #############################################################################

  private

  def row_in_bounds?(row)
    row >= 0 and row < NUM_ROWS
  end

  def column_in_bounds?(column)
    column >= 0 and column < NUM_COLUMNS
  end

  def board_is_full
    (0..NUM_COLUMNS-1).each do |i|
      return false if board_position([i, NUM_ROWS - 1]).nil?
    end
    true
  end

  def check_column(coords)
    check_direction(coords) do |coord, i|
      vertical(coord, i)
    end
  end

  def check_right_diagonal(coords)
    check_direction(coords) do |coord, i|
      diagonal_right(coord, i)
    end
  end

  def check_left_diagonal(coords)
    check_direction(coords) do |coord, i|
      diagonal_left(coord, i)
    end
  end

  def check_row(coords)
    check_direction(coords) do |coord, i|
      horizontal(coord, i)
    end
  end

  def check_direction(coords)
    start_pos = board_position coords
    return false if start_pos.nil?

    (1..3).all? {|i|
      coords_valid?(yield(coords, i)) and board_position(yield(coords, i)) == start_pos
    }
  end
end
