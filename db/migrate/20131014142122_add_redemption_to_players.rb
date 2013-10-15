class AddRedemptionToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :redemption, :boolean, default: false
  end
end
