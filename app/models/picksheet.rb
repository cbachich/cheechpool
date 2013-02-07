# == Schema Information
#
# Table name: picksheets
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  week       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Picksheet < ActiveRecord::Base
  attr_accessible :league_id, :week
  has_many :challenges
end
