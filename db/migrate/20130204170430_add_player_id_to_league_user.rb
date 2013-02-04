class AddPlayerIdToLeagueUser < ActiveRecord::Migration
  def change
    add_column :leagues_users, :player_id, :integer
  end
end
