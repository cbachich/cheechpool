# == Schema Information
#
# Table name: team_picks
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  week       :integer
#  picked     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#

require 'spec_helper'

describe TeamPick do
  pending "add some examples to (or delete) #{__FILE__}"
end
