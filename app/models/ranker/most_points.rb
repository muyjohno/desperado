module Ranker
  class MostPoints < Base
    def self.compare(a, b)
      -(a.points <=> b.points)
    end
  end
end
