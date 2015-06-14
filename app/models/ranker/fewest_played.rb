module Ranker
  class FewestPlayed
    def self.compare(a, b)
      a.played <=> b.played
    end
  end
end
