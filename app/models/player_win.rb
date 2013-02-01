# == Schema Information
#
# Table name: player_wins
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  week       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PlayerWin < ActiveRecord::Base
  attr_accessible :player_id, :week

  belongs_to :players
end
