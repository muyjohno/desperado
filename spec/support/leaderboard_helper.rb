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

def create_sample_leaderboard!
  let(:common_player) { create(:player) }
  let(:game1) { create(:game, corp: common_player, result: :corp_win) }
  let(:game2) { create(:game, runner: common_player, result: :runner_win) }
  let(:leaderboard) { create_leaderboard(games: [game1, game2]) }
end
