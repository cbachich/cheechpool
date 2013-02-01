class CreatePlayerWins < ActiveRecord::Migration
  def change
    create_table :player_wins do |t|
      t.integer :player_id
      t.integer :week

      t.timestamps
    end
  end
end
