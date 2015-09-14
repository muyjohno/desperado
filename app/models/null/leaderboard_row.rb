module Null
  class LeaderboardRow
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def position
    end

    def played
      0
    end

    def corp_wins
      0
    end

    def runner_wins
      0
    end

    def participation_points
      0
    end

    def achievement_points
      0
    end

    def points
      0
    end
  end
end
