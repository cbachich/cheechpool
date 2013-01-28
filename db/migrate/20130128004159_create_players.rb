class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :voted_out_week
      t.string :image_url

      t.timestamps
    end
  end
end
