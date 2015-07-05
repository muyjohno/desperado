class Rule < ActiveRecord::Base
  validates_uniqueness_of :key
end
