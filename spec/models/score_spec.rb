# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  user_id    :integer
#  value      :integer
#  week       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Score do
  pending "add some examples to (or delete) #{__FILE__}"
end
