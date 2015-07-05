class Achievement < ActiveRecord::Base
  has_many :earned_achievements, dependent: :destroy
  has_many :earners, through: :earned_achievements, source: :player

  validates :title, :side, :points, presence: true

  enum side: %w(corp runner)
end
