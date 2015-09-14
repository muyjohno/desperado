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

  let(:game1) { create_game(adam, ben, :corp_win) }
  let(:game2) { create_game(ben, adam, :corp_win) }
  let(:game3) { create_game(adam, chuck, :runner_win) }
  let(:game4) { create_game(chuck, adam, :corp_win) }
  let(:game5) { create_game(ben, chuck, :corp_time_win) }
  let(:game6) { create_game(chuck, ben, :corp_win) }
  let(:game7) { create_game(adam, ben, :runner_win) }
  let(:game8) { create_game(ben, adam, :corp_win) }
  let(:game9) { create_game(adam, chuck, :tie) }
  let(:game10) { create_game(chuck, adam, :runner_win) }
  let(:game11) { create_game(ben, chuck, :corp_time_win) }
  let(:game12) { create_game(chuck, ben, :corp_win) }

  # Breakdown
  # Adam: 2 wins, 5 losses, 1 tie (5 points)
  # Ben: 3 wins, 2 time wins, 3 losses (8 points)
  # Chuck: 4 wins, 3 losses, 1 tie (9 points)

  let(:games) do
    [
      game1, game2, game3, game4, game5, game6,
      game7, game8, game9, game10, game11, game12
    ]
  end

  let(:leaderboard) { create_leaderboard(games: games) }

  let(:adam_row) { leaderboard.row_for(adam) }
  let(:ben_row) { leaderboard.row_for(ben) }
  let(:chuck_row) { leaderboard.row_for(chuck) }
end

def create_sample_league!
  create_sample_league

  before do
    leaderboard
  end
end
