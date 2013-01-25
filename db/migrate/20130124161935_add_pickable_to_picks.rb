class AddPickableToPicks < ActiveRecord::Migration
  def change
    add_column :picks, :pickable_id, :integer
    add_column :picks, :pickable_type, :string
  end
end
