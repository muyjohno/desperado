class Achievement < ActiveRecord::Base
  validates :title, :side, :points, presence: true

  enum side: %w(corp runner)
end
