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
  attr_accessible :board, :created_at, :status, :current_player

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



  # Sets current_player to 'blue' iff current_player has not been initialized
  def initialize(*args)
    super(*args)

    # initialize variables
    # NOTE: Add all initialization here!
    self.board = (0...NUM_COLUMNS).map{[]}
    self.current_player = 'blue' unless self.current_player.present?
    self.status = 'in_progress' unless self.status.present?
  end

  # Gets the next player
  # @return [String] The next player
  def next_player
    # TODO

  end

  # setNextPlayer sets the next player
  #
  # @return [String] The new player
  def set_next_player
    # TODO

  end

  # returns the piece at the coordinates
  def board_position(coords)
    # TODO

  end

  # checks that the given coordinates are within the valid range
  def coords_valid?(coords)
    # TODO

  end

  # MakeMove takes a column and player and updates the board to reflect the
  # given move. Also will update :current_player and :status
  #
  # @param column [Integer]
  # @param player [String] either 'red' or 'blue'
  def make_move(column, player)
    validate_column(column)
    raise ArgumentError, 'invalid player' unless %w(blue red).include? player

    board[column] << player
    @status = check_for_winner
    set_next_player
  end

  # Checks if there is a winner and returns the player if it exists
  #
  # @return [String] 'red', 'blue', 'tie', 'draw', or 'in_progress'
  def check_for_winner
    # TODO

  end



  #############################################################################

  private

    def validate_column(column)
      raise ArgumentError, 'column out of bounds' unless column >= 0 and column < NUM_ROWS
      raise ArgumentError, 'column full' unless board[column].size < NUM_ROWS
    end


end
