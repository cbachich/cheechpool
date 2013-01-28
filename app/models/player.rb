# == Schema Information
#
# Table name: players
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  voted_out_week :integer
#  image_url      :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Player < ActiveRecord::Base
  attr_accessible :image_url, :name, :voted_out_week
end
