# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  email            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  password_digest  :string(255)
#  remember_token   :string(255)
#  admin            :boolean          default(FALSE)
#  active_league_id :integer
#

class User < ActiveRecord::Base
  include SessionsHelper

  attr_accessible :email, 
                  :name, 
                  :password, 
                  :password_confirmation,
                  :active_league_id
  has_secure_password
  has_many :smacks, dependent: :destroy
  has_and_belongs_to_many :leagues
  has_many :team_picks
  has_many :player_picks
  has_many :scores

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  
            presence: true, 
            length: { maximum: 15 }

  validates :email, 
            presence: true, 
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, 
            presence: true,
            length: { minimum: 6 }, 
            on: :create

  validates :password_confirmation,
            presence: true,
            on: :create

  def active_league
    League.find(active_league_id)
  end

  def add_score(league,week,value)
    scores.create(league_id: league.id, week: week, value: value)
  end

  

  def current_player_picks
    league_player_picks.select {|p| p.week == active_league.current_week }
  end

  def league_player_picks
    player_picks.find_all_by_league_id(active_league_id)
  end

  def made_picks?(week)
    player_picks.exists?(week: week) || team_picks.exists?(week: week)
  end

  def player_pick(player)
    current_player_picks.select { |pp| pp.player_id == player.id }.first
  end

  def player_pick_value(player)
    pick = player_pick(player)
    if pick.nil?
      temp_pick = temp_league_values[player]
      if temp_pick.nil?
        ""
      else
        temp_pick
      end
    else
      pick.value
    end
  end

  def save_picks
    league = active_league
    temp_league_values.each do |player, value|
      pick = player_picks.find_by_league_id_and_player_id_and_week(
        league.id, player.id, league.current_week)
      if pick.nil?
        player_picks.create(
             player_id: player.id, 
                 value: value, 
             league_id: league.id,
          challenge_id: "Elimination", 
                  week: league.current_week)
      else
        pick.value = value
        pick.save
      end
    end

    temp_league_selections.each do |challenge, team|
      pick = team_picks.find_by_challenge_id(challenge.id)
      if pick.nil?
        team_picks.create(
               team_id: team.id, 
                picked: true, 
             league_id: league.id,
          challenge_id: challenge.id, 
                  week: league.current_week)
      else
        pick.team_id = team.id
        pick.save
      end
    end

    clear_temp_league_picks
  end

  def set_temporary_player_pick_value(player,value)
    temp_league_values.merge!(player => value)
  end

  def set_temporary_team_selection(challenge,team)
    temp_league_selections.merge!(challenge => team)
  end

  def team_picked?(challenge,team)
    team_pick = 
      team_picks.find_by_challenge_id_and_team_id_and_week_and_picked(
        challenge.id, team.id, active_league.current_week, true)

    if team_pick.nil?
      (temp_league_selections[challenge] == team)
    else
      team_pick.picked
    end
  end

  private

    def clear_temp_league_picks
      league = active_league
      $temp_values.except!(league)
      $temp_selections.except!(league)
    end

    def create_remember_token
      self.remember_token ||= SecureRandom.urlsafe_base64
    end

    def temp_league_picks(o)
      league = active_league
      o.merge!(league => {}) if o[league].nil?
      o[league]
    end

    $temp_selections = {}
    def temp_league_selections
      temp_league_picks($temp_selections)
    end

    $temp_values = {}
    def temp_league_values
      temp_league_picks($temp_values)
    end
end
