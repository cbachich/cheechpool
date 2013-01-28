class AddInfoUrlToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :info_url, :string
  end
end
