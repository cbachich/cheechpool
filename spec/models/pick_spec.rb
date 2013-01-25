# == Schema Information
#
# Table name: picks
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  league_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  pickable_id   :integer
#  pickable_type :string(255)
#  week          :integer
#

require 'spec_helper'

describe Pick do
  pending "add some examples to (or delete) #{__FILE__}"
end
