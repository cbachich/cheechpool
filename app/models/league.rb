# == Schema Information
#
# Table name: leagues
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  current_week         :integer          default(0)
#  picksheet_close_date :datetime
#

class League < ActiveRecord::Base
  include LeaguesHelper

  attr_accessible :name
  has_and_belongs_to_many :users
  has_many :smacks
  has_many :players
  has_many :teams
  has_many :player_picks
  has_many :team_picks
  has_many :picksheets
  has_many :scores

  validates :name, presence:true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def user_in_league(user)
    if self.users.any?
      self.users.exists?(user)
    end
  end

  def add_scores_for_week(week)
    users = self.users
    challenges = self.picksheets.find_by_week(week).challenges
    total_players = number_of_players(self,week)

    users.each do |user|
      value = 0
      challenges.each do |challenge|
        if challenge.name == "Elimination"
          voted_out_players = self.players.find_all_by_voted_out_week(week)
          voted_out_players.each do |voted_out_player|
            player_pick = user.player_picks.find_by_player_id_and_league_id_and_week(voted_out_player.id, self.id, week)
            if !player_pick.nil?
             value += scaled_value(player_pick.value,total_players)
            end
          end
        else
          winner = TeamWin.find_by_challenge_id(challenge.id)
          team_pick = 
            user.team_picks.
              find_by_challenge_id_and_team_id_and_week_and_picked(
                challenge.id, winner.team_id, week, true)

          if !team_pick.nil? && team_pick.picked
            value += 10
          end
        end
      end

      user.scores.create(league_id: self.id, week: week, value: value)
    end
  end
end
