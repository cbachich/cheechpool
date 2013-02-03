class AddChallengeIdToPicks < ActiveRecord::Migration
  def change
    add_column :player_picks, :challenge_id, :integer
    add_column :team_picks, :challenge_id, :integer
  end
end
