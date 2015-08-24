class Tiebreaker < ActiveRecord::Base
  enum tiebreaker: [:most_points, :most_weak_side_wins, :fewest_played]
  validates_uniqueness_of :tiebreaker

  scope :ordered, -> { order(ordinal: :asc) }
end
