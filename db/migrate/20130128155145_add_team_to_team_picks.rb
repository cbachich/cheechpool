class AddTeamToTeamPicks < ActiveRecord::Migration
  def change
    add_column :team_picks, :team_id, :integer 
  end
end
