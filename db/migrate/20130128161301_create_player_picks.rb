class CreatePlayerPicks < ActiveRecord::Migration
  def change
    create_table :player_picks do |t|
      t.integer :player_id
      t.integer :user_id
      t.integer :league_id
      t.integer :week
      t.integer :value
      t.boolean :picked

      t.timestamps
    end
  end
end
