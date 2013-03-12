#  Here are the routes which are generated. Run `bundle exec rake routes`.
#
#   Route name      | Verb   | Path                        | Controller#Action
#   ---------------------------------------------------------------------------
#   games            GET      /games(.:format)               games#index
#                    POST     /games(.:format)               games#create
#   new_game         GET      /games/new(.:format)           games#new
#   edit_game        GET      /games/:id/edit(.:format)      games#edit
#   game             GET      /games/:id(.:format)           games#show
#                    PUT      /games/:id(.:format)           games#update
#                    DELETE   /games/:id(.:format)           games#destroy

ConnectFourWWC::Application.routes.draw do

  # Rails relies heavily on the idea of RESTful "resources".
  #   - http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions

  resources :games
  post '/games/:id/move' => 'games#move', :as => 'move'

  root :to => "games#index"

end
