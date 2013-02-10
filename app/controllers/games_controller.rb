class GamesController < ApplicationController

  # Display a list of all games
  #   Should set the @games instance variable to a list of all games
  #
  # @verb GET
  # @path /games
  def index
    @games = Game.all
  end

  # Show a form for creating a new game
  #   Should set the @game instance variable to a new, unsaved game
  #
  # @verb GET
  # @path /games/new
  def new
    @game = Game.new
  end

  # Shows game with given :id
  #   Should set the @game variable to the given game object
  #
  # @verb GET
  # @path /games/:id
  def show
    @game = Game.find_by_id(:id)
  end

  # Creates a game recourse
  #
  # @verb POST
  # @path /games
  def create
    # TODO
  end

  # Destroys given game
  #
  # @verb DELETE
  # @path /games/:id
  def destroy
    # TODO
  end


  # Makes a move
  #
  # @verb POST
  # @path /games/:id/move
  # @param [String] :player The player making the move
  # @param [Int] :column The column the move is made on
  def move
    # TODO
  end

end

