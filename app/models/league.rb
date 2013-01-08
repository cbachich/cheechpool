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

  before_save { |league| league.name = name.downcase }

  validates :name, presence:true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
end
