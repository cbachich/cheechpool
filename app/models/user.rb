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

  def league_player(league)
    player_id =
      LeagueUser.find_by_user_id_and_league_id(self.id,league.id).player_id
    Player.find(player_id)
  end

  def add_score(week,value)
    scores.create(league_id: active_league.id, week: week, value: value)
  end

  def delete_score(week)
    s = scores.find_by_week(week)
    if !s.nil?
      s.delete
    end
  end

  def current_player_value_picks
    player_value_picks_for_week(active_league.current_week)
  end

  def player_value_picks_for_week(week)
    league_player_value_picks.select { 
      |p| p.week == week 
    }.sort { |a,b| a.value <=> b.value }
  end

  def players_for_week(week)
    player_value_picks_for_week(week).map { |pp| pp.player }
  end

  def week_score(week)
    score = scores.find_by_league_id_and_week(active_league.id, week)
    if score.nil?
      0
    else
      score.value
    end
  end
  
  def league_player_value_picks
    player_picks.where("league_id = ? AND value >= 0",active_league_id)
  end

  def made_picks?(week)
    player_picks.exists?(week: week) || team_picks.exists?(week: week)
  end

  def player_value_pick(player)
    current_player_value_picks.select { |pp| pp.player_id == player.id }.first
  end

  def player_pick_value_display(player)
    pick = player_value_pick(player)
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
      pick = player_value_pick(player)
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

    temp_league_selections.each do |challenge, object|
      if object.is_a? Player
        pick = player_picks.find_by_challenge_id(challenge.id)
        if pick.nil?
          player_picks.create(
               player_id: object.id,
                  picked: true,
               league_id: league.id,
            challenge_id: challenge.id,
                    week: league.current_week)
        else
          pick.player_id = object.id
          pick.save
        end
      else
        pick = team_picks.find_by_challenge_id(challenge.id)

        if pick.nil?
          team_picks.create(
                 team_id: object.id, 
                  picked: true, 
               league_id: league.id,
            challenge_id: challenge.id, 
                    week: league.current_week)
        else
          pick.team_id = object.id
          pick.save
        end
      end
     
    end

    clear_temp_league_picks
  end

  def set_temporary_player_pick_value(player,value)
    temp_league_values.merge!(player => value)
  end

  def set_temporary_selection(challenge,object)
    temp_league_selections.merge!(challenge => object)
  end

  def pick(challenge)
    pp = player_picks.where(challenge_id: challenge.id)
    if !pp.empty?
      object = pp.first.player
    else
      tp = team_picks.where(challenge_id: challenge.id)
      object = tp.first.team if !tp.empty?
    end
    object
  end

  def picked?(challenge,object)
    if challenge.is_players?
      pick = 
        player_picks.where(challenge_id: challenge.id, player_id: object.id)
    else
      pick = 
        team_picks.where(challenge_id: challenge.id, team_id: object.id)
    end

    if pick.empty? 
      #(temp_league_selections[challenge] == object)
      false
    else
      pick = pick.first
      pick.picked = false if pick.picked.nil?
      pick.picked
    end
  end

  def total_score
    total = 0
    league_scores = scores.find_all_by_league_id(active_league.id)
    league_scores.each do |score|
      total += score.value
    end
    total
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
