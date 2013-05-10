class AddFinaleWeekToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :finale_week, :integer
  end
end
