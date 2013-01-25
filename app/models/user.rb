# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :email, 
                  :name, 
                  :password, 
                  :password_confirmation,
                  :active_league_id
  has_secure_password
  has_many :smacks, dependent: :destroy
  has_many :picks
  has_and_belongs_to_many :leagues

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  
            presence: true, 
            length: { maximum: 50 }

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

  private

    def create_remember_token
      self.remember_token ||= SecureRandom.urlsafe_base64
    end
end
