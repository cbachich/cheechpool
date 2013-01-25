# == Schema Information
#
# Table name: picks
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  week       :integer
#  value      :integer
#  picked     :boolean
#

class Pick < ActiveRecord::Base
  belongs_to :user
  belongs_to :league

  validates :user_id, presence: true
  validates :league_id, presence: true
end
