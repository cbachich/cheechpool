class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :league_id
      t.integer :user_id
      t.integer :value
      t.integer :week

      t.timestamps
    end
  end
end
