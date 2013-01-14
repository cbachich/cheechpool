class AddAdminToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues_users, :admin, :boolean, default: false 
  end
end
