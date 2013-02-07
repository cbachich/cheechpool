class CreatePicksheets < ActiveRecord::Migration
  def change
    create_table :picksheets do |t|
      t.integer :league_id
      t.integer :week

      t.timestamps
    end
    add_column :challenges, :picksheet_id, :integer
  end
end
