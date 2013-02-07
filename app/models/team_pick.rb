# == Schema Information
#
# Table name: team_picks
#
#  id           :integer          not null, primary key
#  picked       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_id      :integer
#  challenge_id :integer
#  user_id      :integer
#  league_id    :integer
#  week         :integer
#

class TeamPick < ActiveRecord::Base
  attr_accessible :league_id, :team_id, :picked, :user_id, :value, :week, :challenge_id
  belongs_to :users
  belongs_to :leagues
end
