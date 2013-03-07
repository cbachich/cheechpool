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

  def add_score(league,week,value)
    scores.create(league_id: league.id, week: week, value: value)
  end

  def player_pick(player, league, week)
    player_picks.find_by_player_id_and_league_id_and_week(player.id, league.id, week)
  end

  def team_picked?(challenge,winner,week)
    team_pick = 
      team_picks.find_by_challenge_id_and_team_id_and_week_and_picked(
        challenge.id, winner.team_id, week, true)

    (!team_pick.nil? && team_pick.picked)
  end

  private

    def create_remember_token
      self.remember_token ||= SecureRandom.urlsafe_base64
    end
end
