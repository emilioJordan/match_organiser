class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :match

  validates :status, presence: true, inclusion: { in: %w[confirmed declined pending] }
  validates :user_id, uniqueness: { scope: :match_id, message: "can only participate once per match" }

  scope :confirmed, -> { where(status: 'confirmed') }
  scope :declined, -> { where(status: 'declined') }
  scope :pending, -> { where(status: 'pending') }
end
