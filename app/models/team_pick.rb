# == Schema Information
#
# Table name: team_picks
#
#  id         :integer          not null, primary key
#  picked     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#  week_id    :integer
#

class TeamPick < ActiveRecord::Base
  attr_accessible :league_id, :team_id, :picked, :user_id, :value, :week
  belongs_to :weeks
end
