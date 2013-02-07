# == Schema Information
#
# Table name: challenges
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  picksheet_id :integer
#  player       :boolean
#

require 'spec_helper'

describe Challenge do
  pending "add some examples to (or delete) #{__FILE__}"
end
