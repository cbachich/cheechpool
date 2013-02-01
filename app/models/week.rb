# == Schema Information
#
# Table name: weeks
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  user_id    :integer
#  score      :integer
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Week < ActiveRecord::Base
  attr_accessible :league_id, :number, :score, :user_id

  has_many :player_picks
  has_many :team_picks
end
