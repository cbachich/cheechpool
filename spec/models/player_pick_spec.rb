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

require 'spec_helper'

describe PlayerPick do
  pending "add some examples to (or delete) #{__FILE__}"
end
