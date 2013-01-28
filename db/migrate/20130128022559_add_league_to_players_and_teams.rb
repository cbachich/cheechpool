class AddLeagueToPlayersAndTeams < ActiveRecord::Migration
  def change
    add_column :players, :league_id, :integer
    add_column :teams, :league_id, :integer
  end
end
