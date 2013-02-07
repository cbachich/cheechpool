class AddPlayerBooleanToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :player, :boolean
  end
end
