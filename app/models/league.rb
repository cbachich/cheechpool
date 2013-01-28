# == Schema Information
#
# Table name: leagues
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class League < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :users
  has_many :smacks
  has_many :players
  has_many :teams
  has_many :player_picks
  has_many :team_picks

  validates :name, presence:true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def user_in_league(user)
    if self.users.any?
      self.users.exists?(user)
    end
  end
end
