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

  def close_picksheet_now
    self.picksheet_close_date = DateTime.current
    save
  end

  def current_challenges
    challenges_for_week(current_week)
  end

  def merge_teams(img_url)
    new_team = teams.create(name: "Merged", start_week: current_week, image_url: img_url)
    players_left.each do |player|
      player.team = new_team
      player.save
    end
  end

  def move_week(cutoff_date,new_challenges)
    self.current_week += 1
    self.picksheet_close_date = cutoff_date
    picksheet = self.picksheets.create(week: current_week)
    new_challenges.each do |challenge|
      picksheet.challenges.create(name: challenge[:name], player: challenge[:player])
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
    players.select {|p| !p.voted_out_by?(week-1) }
  end

  def players_left
    players.select {|p| !p.voted_out_by?(current_week) }
  end

  def set_results(eliminated_players,winners)
    eliminated_players.each { |player| player.voted_out(current_week) }
    winners.each do |winner| 
      if winner[:challenge].is_players?
        winner[:challenge].player_winner(winner[:object])
      else
        winner[:challenge].team_winner(winner[:object])
      end
    end
    add_scores(eliminated_players)
  end

  def teams_left
    players_left.map{|p|Team.find(p.team_id)}.uniq
  end

  def user_in_league(user)
    if users.any?
      users.exists?(user)
    end
  end

  def users_by_total_score
    users.sort{|u1,u2| u2.total_score <=> u1.total_score}
  end

  def users_by_week_score(week)
    users.sort{|u1,u2| u2.week_score(week) <=> u1.week_score(week)}
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
            eliminated_players.each do |player|
              player_pick = user.player_value_pick(player)
              if !player_pick.nil?
                value += scaled_value(player_pick.value,total_players)
              end
            end
          else
            challenge.winners.each do |winner|
              if winner.is_a? PlayerWin
                object = winner.player
              else
                object = winner.team
              end

              if user.picked?(challenge,object)
                value += 10
              end
            end
          end
        end

        user.add_score(current_week,value)
      end
    end

end
