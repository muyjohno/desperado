class Rule < ActiveRecord::Base
  belongs_to :league
  before_save :update_ordinal

  validates_uniqueness_of :key

  KEYS = [
    :points_for_win,
    :points_for_loss,
    :points_for_tie,
    :points_for_time_win,
    :points_for_participation,
    :max_points_for_participation
  ]

  def self.value_for(key, default = nil)
    rule_for(key).value || default
  end

  def self.rule_for(key)
    find_by(key: key) || Rule.new(key: key)
  end

  def update_ordinal
    self.ordinal = KEYS.index(key.to_sym)
  end
end
