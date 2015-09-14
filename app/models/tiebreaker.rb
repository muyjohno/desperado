class Tiebreaker < ActiveRecord::Base
  enum tiebreaker: [
    :most_points,
    :most_weak_side_wins,
    :fewest_played,
    :highest_strength_of_schedule
  ]
  validates :tiebreaker, uniqueness: true

  include RankedModel
  ranks :ordinal
  scope :ordered, -> { rank(:ordinal) }

  def self.available_tiebreakers
    taken = pluck(:tiebreaker)
    tiebreakers.reject { |_, v| taken.include?(v) }
  end
end
