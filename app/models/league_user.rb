class LeagueUser < ActiveRecord::Base
  set_table_name "leagues_users"

  attr_accessible :league_id, :user_id, :created_at, :admin

  has_many :leagues
  has_many :users
end
