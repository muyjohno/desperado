def create_sample_league
  before do
    create(:rule, key: :points_for_win, value: 2)
    create(:rule, key: :points_for_time_win, value: 1)
    create(:rule, key: :points_for_tie, value: 1)
    create(:rule, key: :points_for_loss, value: 0)
    create(:rule, key: :points_for_participation, value: 1)
    create(:tiebreaker, tiebreaker: :most_points)
  end

  let(:adam) { create(:player, name: "Adam") }
  let(:ben) { create(:player, name: "Ben") }
  let(:chuck) { create(:player, name: "Chuck") }

  let(:game1) { create(:game, corp: adam, runner: ben, result: :corp_win) }
  let(:game2) { create(:game, corp: ben, runner: adam, result: :corp_win) }
  let(:game3) { create(:game, corp: adam, runner: chuck, result: :runner_win) }
  let(:game4) { create(:game, corp: chuck, runner: adam, result: :corp_win) }
  let(:game5) { create(:game, corp: ben, runner: chuck, result: :corp_time_win) }
  let(:game6) { create(:game, corp: chuck, runner: ben, result: :corp_win) }
  let(:game7) { create(:game, corp: adam, runner: ben, result: :runner_win) }
  let(:game8) { create(:game, corp: ben, runner: adam, result: :corp_win) }
  let(:game9) { create(:game, corp: adam, runner: chuck, result: :tie) }
  let(:game10) { create(:game, corp: chuck, runner: adam, result: :runner_win) }
  let(:game11) { create(:game, corp: ben, runner: chuck, result: :corp_time_win) }
  let(:game12) { create(:game, corp: chuck, runner: ben, result: :corp_win) }

  # Breakdown
  # Adam: 2 wins, 5 losses, 1 tie
  # Ben: 3 wins, 2 time wins, 3 losses
  # Chuck: 4 wins, 3 losses, 1 tie

  let(:games) do
    [
      game1, game2, game3, game4, game5, game6,
      game7, game8, game9, game10, game11, game12
    ]
  end

  let(:leaderboard) { create_leaderboard(games: games) }
end

def create_sample_league!
  create_sample_league

  before do
    leaderboard
  end
end
