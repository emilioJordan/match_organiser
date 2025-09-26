class User < ApplicationRecord
  has_secure_password

  has_many :created_matches, class_name: 'Match', foreign_key: 'created_by_id', dependent: :destroy
  
  has_many :participations, dependent: :destroy
  has_many :matches, through: :participations

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[organizer player] }
  validates :password, confirmation: true, length: { minimum: 8 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validate :password_complexity, on: :create

  def organizer?
    role == 'organizer'
  end

  def player?
    role == 'player'
  end

  def confirmed_matches
    matches.joins(:participations).where(participations: { status: 'confirmed' })
  end

  private

  def password_complexity
    return if password.blank?
    return if password.match?(/[^A-Za-z]/) 
    
    errors.add(:password, :complexity)
  end
end
