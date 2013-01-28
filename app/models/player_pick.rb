# == Schema Information
#
# Table name: player_picks
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  user_id    :integer
#  league_id  :integer
#  week       :integer
#  value      :integer
#  picked     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PlayerPick < ActiveRecord::Base
  attr_accessible :league_id, :picked, :player_id, :user_id, :value, :week
  belongs_to :users
  belongs_to :leagues
end
