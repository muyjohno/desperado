module Spec
  module LeaderboardHelper
    def create_leaderboard(games: default_games, ruleset: default_ruleset)
      Leaderboard.new(games, ruleset)
    end

    def default_games
      [create(:game), create(:game)]
    end

    def default_ruleset
      @ruleset ||= Ruleset.new
    end
  end
end
