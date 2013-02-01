class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.integer :league_id
      t.integer :user_id
      t.integer :score
      t.integer :number

      t.timestamps
    end
  end
end
