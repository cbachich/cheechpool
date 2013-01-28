# == Schema Information
#
# Table name: team_picks
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  week       :integer
#  picked     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#

class TeamPick < ActiveRecord::Base
  attr_accessible :league_id, :team_id, :picked, :user_id, :value, :week
  belongs_to :users
  belongs_to :leagues
end
