require 'factory_girl'

FactoryGirl.define do 
  sequence(:empty_board){ Array.new(Game::NUM_COLUMNS).map{[]} }
end

FactoryGirl.define do 
  factory :game, :class => Game do 
    board { generate :empty_board }
    red_player_name "red"
    blue_player_name "blue"
  end

end
