class AddWeekToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :current_week, :integer, default: 1
  end
end
