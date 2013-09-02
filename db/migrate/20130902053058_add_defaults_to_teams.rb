class AddDefaultsToTeams < ActiveRecord::Migration
  def up
    change_column :teams, :start_week, :integer, :default => 1
  end

  def down
    change_column :teams, :start_week, :integer, :default => nil
  end
end
