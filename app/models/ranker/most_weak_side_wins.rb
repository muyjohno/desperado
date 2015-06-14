module Ranker
  class MostWeakSideWins
    def self.compare(a, b)
      -(a.weak_side_wins <=> b.weak_side_wins)
    end
  end
end
