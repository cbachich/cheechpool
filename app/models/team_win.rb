# == Schema Information
#
# Table name: team_wins
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  week       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TeamWin < ActiveRecord::Base
  attr_accessible :team_id, :week

  belongs_to :teams
end
