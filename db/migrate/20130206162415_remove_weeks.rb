class RemoveWeeks < ActiveRecord::Migration
  def up
    drop_table :weeks

    remove_column :player_picks, :week_id
    add_column :player_picks, :user_id, :integer
    add_column :player_picks, :league_id, :integer
    add_column :player_picks, :week, :integer

    remove_column :team_picks, :week_id
    add_column :team_picks, :user_id, :integer
    add_column :team_picks, :league_id, :integer
    add_column :team_picks, :week, :integer
  end

  def down
  end
end
