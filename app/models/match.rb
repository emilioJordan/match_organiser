class Match < ApplicationRecord
  has_paper_trail
  
  belongs_to :created_by, class_name: 'User'
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user

  validates :title, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :location, presence: true

  scope :upcoming, -> { where('date >= ?', Date.current) }
  scope :past, -> { where('date < ?', Date.current) }

  def confirmed_participants
    participants.joins(:participations).where(participations: { status: 'confirmed' }).distinct
  end

  def declined_participants
    participants.joins(:participations).where(participations: { status: 'declined' }).distinct
  end

  def pending_participants
    participants.joins(:participations).where(participations: { status: 'pending' }).distinct
  end

  def participant_status_for(user)
    participation = participations.find_by(user: user)
    participation&.status || 'not_participating'
  end
end
