class CreateTeamPicks < ActiveRecord::Migration
  def change
    create_table :team_picks do |t|
      t.integer :user_id
      t.integer :league_id
      t.integer :week
      t.boolean :picked

      t.timestamps
    end
  end
end
