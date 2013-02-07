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

require 'spec_helper'

describe TeamPick do
  pending "add some examples to (or delete) #{__FILE__}"
end
