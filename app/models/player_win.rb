# == Schema Information
#
# Table name: player_wins
#
#  id           :integer          not null, primary key
#  player_id    :integer
#  week         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#

class PlayerWin < ActiveRecord::Base
  attr_accessible :player_id, :week, :challenge_id

  belongs_to :players
end
