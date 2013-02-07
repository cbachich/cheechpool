# == Schema Information
#
# Table name: leagues_users
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean          default(FALSE)
#  player_id  :integer
#

class LeagueUser < ActiveRecord::Base
  set_table_name "leagues_users"

  attr_accessible :league_id, :user_id, :created_at, :admin

  has_many :leagues
  has_many :users
end
