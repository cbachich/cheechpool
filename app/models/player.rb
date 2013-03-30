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
#  team_id        :integer
#  league_id      :integer
#  info_url       :string(255)
#

class Player < ActiveRecord::Base
  attr_accessible :info_url, :image_url, :name, :voted_out_week, :league_id

  has_many :player_wins
  has_many :player_picks

  belongs_to :teams
  belongs_to :leagues

  def voted_out?
    !voted_out_week.nil?
  end

  def voted_out_by?(week)
    voted_out? && (voted_out_week <= week)
  end

  def voted_out_this_week?(week)
    voted_out? && (voted_out_week == week)
  end

  def voted_out(week)
    self.voted_out_week = week
    self.save
  end

  def won_challenge?(challenge)
    pw = PlayerWin.find_by_challenge_id(challenge.id)
    (!pw.nil? && (pw.player_id == self.id))
  end
end
