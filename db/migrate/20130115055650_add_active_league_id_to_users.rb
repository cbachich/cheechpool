class AddActiveLeagueIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_league_id, :integer
  end
end
