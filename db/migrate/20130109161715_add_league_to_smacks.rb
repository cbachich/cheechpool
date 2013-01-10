class AddLeagueToSmacks < ActiveRecord::Migration
  def change
    add_column :smacks, :league_id, :integer
  end
end
