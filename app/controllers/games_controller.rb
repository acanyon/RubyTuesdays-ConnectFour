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
    @game = Game.find_by_id(params[:id]) || not_found # the internet says I should use the ActiveController::RecordNotFound error
  end

  # Creates a game recourse
  #
  # @verb POST
  # @path /games
  def create
    game = Game.create!

    redirect_to game_url(game), :status => :created
    # amanda's version: (for me, only leads to text of the response)
    #render :json => {:success => true,
    #                 :id => @game.id,
    #                 :game => @game},
    #       :status => :created
  end

  # Destroys given game
  #
  # @verb DELETE
  # @path /games/:id
  def destroy
    game = get_game params[:id]
    return if game.nil?
    game.destroy
    redirect_to games_url, :status => :ok
  end


  # Makes a move
  #
  # @verb POST
  # @path /games/:id/move
  # @param [String] :player The player making the move
  # @param [Int] :column The column the move is made on
  def move
    game = get_game params[:id]
    return if game.nil?
puts params[:player]
    game.make_move(params[:column].to_i, params[:player].to_s)

    #unless Game.exists?(params[:id])
    #  render :json => {:success => false,
    #                   :id => params[:id]},
    #         :status => 404
    #else
    #  game = Game.find(params[:id])
    #  success = game.make_move(params['column'].to_i, params['player'])
    #  render :json => {:success => success,
    #                   :id => game.id,
    #                   :game => game,
    #                   :state => game.status},
    #         :status => (success ? 200 : 400)
    #end
  end

  private

  def not_found
    render :status => 404
    #raise ActionController::RoutingError.new('Not Found')
  end

  def get_game(id)
    game = Game.find_by_id(id)
    if game.nil?
      redirect_to games_url, :status => :not_found
      return nil
    end
    game
  end

end

