# == Schema Information
#
# Table name: challenges
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  picksheet_id :integer
#  player       :boolean
#

class Challenge < ActiveRecord::Base
  attr_accessible :name, :picksheet_id, :player
  has_many :player_wins
  has_many :team_wins
  belongs_to :picksheets

  def is_players?
    if player.nil?
      false
    else
      player
    end
  end

  def week
    Picksheet.find(self.picksheet_id).week
  end

  def player_winner(player)
    self.player_wins.create(player_id: player.id, week: week)
  end

  def team_winner(team)
    self.team_wins.create(team_id: team.id, week: week)
  end

  def winners
    team_wins.all | player_wins.all 
  end
end
