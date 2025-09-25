class User < ApplicationRecord
  has_secure_password

  # Matches created by this user
  has_many :created_matches, class_name: 'Match', foreign_key: 'created_by_id', dependent: :destroy
  
  # Participations in matches
  has_many :participations, dependent: :destroy
  has_many :matches, through: :participations

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[organizer player] }

  def organizer?
    role == 'organizer'
  end

  def player?
    role == 'player'
  end

  def confirmed_matches
    matches.joins(:participations).where(participations: { status: 'confirmed' })
  end
end
