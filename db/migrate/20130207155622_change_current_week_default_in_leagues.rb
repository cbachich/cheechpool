class ChangeCurrentWeekDefaultInLeagues < ActiveRecord::Migration
  def up
    change_column :leagues, :current_week, :integer, default: 0
  end

  def down
  end
end
