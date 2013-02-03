class AddChallengeIdToWin < ActiveRecord::Migration
  def change
    add_column :player_wins, :challenge_id, :integer
    add_column :team_wins, :challenge_id, :integer
  end
end
