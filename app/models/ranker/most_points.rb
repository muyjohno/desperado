module Ranker
  class MostPoints
    def self.compare(a, b)
      -(a.points <=> b.points)
    end
  end
end
