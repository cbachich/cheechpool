class CreateSmacks < ActiveRecord::Migration
  def change
    create_table :smacks do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :smacks, [:user_id, :created_at]
  end
end
