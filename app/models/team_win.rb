# == Schema Information
#
# Table name: team_wins
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  week         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#

class TeamWin < ActiveRecord::Base
  attr_accessible :team_id, :week, :challenge_id

  belongs_to :teams
  belongs_to :challenges
end
