class CreateTeamWins < ActiveRecord::Migration
  def change
    create_table :team_wins do |t|
      t.integer :team_id
      t.integer :week

      t.timestamps
    end
  end
end
