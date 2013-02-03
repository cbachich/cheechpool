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

require 'spec_helper'

describe PlayerWin do
  pending "add some examples to (or delete) #{__FILE__}"
end
