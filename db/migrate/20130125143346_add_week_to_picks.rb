class AddWeekToPicks < ActiveRecord::Migration
  def change
    add_column :picks, :week, :integer
  end
end
