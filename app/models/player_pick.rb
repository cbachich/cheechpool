# == Schema Information
#
# Table name: player_picks
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  value      :integer
#  picked     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  week_id    :integer
#

class PlayerPick < ActiveRecord::Base
  attr_accessible :league_id, :picked, :player_id, :user_id, :value, :week
  belongs_to :weeks
end
