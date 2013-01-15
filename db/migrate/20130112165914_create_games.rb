class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :created_at
      t.string   :current_player
      t.string   :status
      t.text     :board

      t.timestamps
    end
  end
end
