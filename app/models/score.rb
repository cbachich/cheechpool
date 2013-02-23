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

class Score < ActiveRecord::Base
  attr_accessible :league_id, :user_id, :value, :week
  belongs_to :leagues
  belongs_to :users
end
