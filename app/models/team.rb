# == Schema Information
#
# Table name: teams
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  start_week   :integer
#  disband_week :integer
#  image_url    :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  league_id    :integer
#

class Team < ActiveRecord::Base
  attr_accessible :disband_week, :image_url, :name, :start_week
  has_many :players
  belongs_to :leagues
end
