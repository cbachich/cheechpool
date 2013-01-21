# == Schema Information
#
# Table name: smacks
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Smack < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  belongs_to :league

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validates :league_id, presence: true

  default_scope order: 'smacks.created_at DESC'
end
