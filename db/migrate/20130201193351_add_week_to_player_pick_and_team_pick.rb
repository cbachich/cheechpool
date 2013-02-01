class AddWeekToPlayerPickAndTeamPick < ActiveRecord::Migration
  def change
    change_table :team_picks do |t|
      t.remove :user_id, :league_id, :week
      t.integer :week_id
    end
    change_table :player_picks do |t|
      t.remove :user_id, :league_id, :week
      t.integer :week_id
    end
  end
end
