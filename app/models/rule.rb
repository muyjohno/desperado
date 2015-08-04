class Rule < ActiveRecord::Base
  belongs_to :league
  before_save :update_ordinal

  validates_uniqueness_of :key

  KEYS = {
    points_for_win:       0,
    points_for_loss:      1,
    points_for_tie:       2,
    points_for_time_win:  3
  }

  def self.value_for(key)
    rule_for(key).value
  end

  def self.rule_for(key)
    find_by(key: key) || Rule.new(key: key)
  end

  def update_ordinal
    ordinal = KEYS[key.to_sym]
  end
end
