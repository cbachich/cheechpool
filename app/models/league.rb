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

  def challenges_for_week(week)
    if picksheet_for_week?(week)
      picksheet_for_week(week).challenges
    else
      []
    end
  end

  def current_challenges
    challenges_for_week(current_week)
  end

  def move_week(cutoff_date,new_challenges)
    self.current_week += 1
    self.picksheet_close_date = cutoff_date
    picksheet = self.picksheets.create(week: current_week)
    new_challenges.each do |challenge|
      picksheet.challenges.create(name: challenge)
    end
    save
  end

  def picksheet_closed?
    picksheet_close_date.nil? || (DateTime.current > picksheet_close_date)
  end
  
  def picksheet_for_week?(week)
    !picksheet_for_week(week).nil?
  end

  def picksheet_for_week(week)
    picksheets.find_by_week(week)
  end

  def players_for_week(week)
    players.select {|p| !p.voted_out_by?(week) }
  end

  def players_left
    players.select {|p| !p.voted_out_by?(current_week) }
  end

  def set_results(eliminated_players,winners)
    eliminated_players.each { |player| player.voted_out(current_week) }
    winners.each { |winner| winner[:challenge].team_winner(winner[:team]) }
    add_scores(eliminated_players)
  end

  def user_in_league(user)
    if users.any?
      users.exists?(user)
    end
  end

  def voted_out_players
    players.find_all_by_voted_out_week(current_week)
  end

  private

    def add_scores(eliminated_players)
      challenges = current_challenges
      total_players = players_left.count + eliminated_players.count

      users.each do |user|
        value = 0
        challenges.each do |challenge|
          if challenge.name == "Elimination"
            eliminated_players.each do |eliminated_player|
              player_pick = user.player_pick(eliminated_player, self, current_week)
              if !player_pick.nil?
                value += scaled_value(player_pick.value,total_players)
              end
            end
          else
            winner = TeamWin.find_by_challenge_id(challenge.id)
            if user.team_picked?(challenge,winner,current_week)
              value += 10
            end
          end
        end

        user.add_score(self,current_week,value)
      end
    end

end
