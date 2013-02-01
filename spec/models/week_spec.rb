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

require 'spec_helper'

describe Week do
  pending "add some examples to (or delete) #{__FILE__}"
end
