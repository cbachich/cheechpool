class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :start_week
      t.integer :disband_week
      t.string :image_url

      t.timestamps
    end
  end
end
