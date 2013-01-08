class AddIndexToLeaguesName < ActiveRecord::Migration
  def change
    add_index :leagues, :name, unique: true
  end
end
