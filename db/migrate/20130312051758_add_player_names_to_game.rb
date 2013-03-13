class AddPlayerNamesToGame < ActiveRecord::Migration
  def up
    change_table :games do |t|
      t.string   :red_player_name
      t.string   :blue_player_name
    end

    # initialize the new columns with generic values
    Game.reset_column_information
    Game.all.each do |game|
      game.update_attributes!(:red_player_name => 'red', :blue_player_name => 'blue')
    end
  end

  def down
    change_table :games do |t|
      t.remove   :red_player_name, :blue_player_name
    end
  end
end
