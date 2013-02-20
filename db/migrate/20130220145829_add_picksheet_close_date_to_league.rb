class AddPicksheetCloseDateToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :picksheet_close_date, :datetime
  end
end
