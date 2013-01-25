class Pick < ActiveRecord::Base
  belongs_to :pickable, polymorphic: true
  belongs_to :user
  belongs_to :league

  validates :user_id, presence: true
  validates :league_id, presence: true
end
