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

class Pick < ActiveRecord::Base
  belongs_to :pickable, polymorphic: true
  belongs_to :user
  belongs_to :league

  validates :user_id, presence: true
  validates :league_id, presence: true
end
