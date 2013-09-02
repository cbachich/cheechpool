# == Schema Information
#
# Table name: teams
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  start_week   :integer          default(1)
#  disband_week :integer
#  image_url    :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  league_id    :integer
#

class Team < ActiveRecord::Base
  attr_accessible :disband_week, :image_url, :name, :start_week
  
  has_many :players
  has_many :team_wins
  has_many :team_picks

  belongs_to :league

  def players_left
    players.select {|p| !p.voted_out_by?(league.current_week) }
  end

  def won_challenge?(challenge)
    team_win = TeamWin.find_by_challenge_id(challenge.id)
    (!team_win.nil? && (team_win.team_id == self.id))
  end
end
