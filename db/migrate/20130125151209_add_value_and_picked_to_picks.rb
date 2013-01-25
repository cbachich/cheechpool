class AddValueAndPickedToPicks < ActiveRecord::Migration
  def change
    add_column :picks, :value, :integer
    add_column :picks, :picked, :boolean
  end
end
