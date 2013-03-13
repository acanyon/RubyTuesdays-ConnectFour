#  Here are the routes which are generated. Run `bundle exec rake routes`.
#
#   Route name      | Verb   | Path                        | Controller#Action
#   ---------------------------------------------------------------------------
#   games            GET      /games(.:format)               games#index
#                    POST     /games(.:format)               games#create
#   new_game         GET      /games/new(.:format)           games#new
#   game             GET      /games/:id(.:format)           games#show
#                    DELETE   /games/:id(.:format)           games#destroy
#   move POST                 /games/:id/move(.:format)      games#move
#   root                      /                              games#index


ConnectFourWWC::Application.routes.draw do

  # Rails relies heavily on the idea of RESTful "resources".
  #   - http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions

  resources :games, :except => [:edit, :update] 
  post '/games/:id/move' => 'games#move', :as => 'move'

  root :to => "games#index"

end
