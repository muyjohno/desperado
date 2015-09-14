module Ranker
  class FewestPlayed < Base
    def self.compare(a, b)
      a.played <=> b.played
    end
  end
end
