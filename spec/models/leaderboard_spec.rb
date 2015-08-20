RSpec.describe Leaderboard, type: :model do
  let(:common_player) { create(:player) }
  let(:game1) { create(:game, corp: common_player, result: :corp_win) }
  let(:game2) { create(:game, runner: common_player, result: :runner_win) }
  let(:leaderboard) { create_leaderboard(games: [game1, game2]) }

  it "should build correct leaderboard" do
    expect(leaderboard.rows.count).to be(3)
  end

  context "row" do
    before do
      create(:rule, key: :points_for_win, value: 2)
      create(:rule, key: :points_for_participation, value: 2)
    end

    let(:row) { leaderboard.rows[common_player.id] }

    describe("#played") { it { expect(row.played).to be(2) } }
    describe("#corp_wins") { it { expect(row.corp_wins).to be(1) } }
    describe("#runner_wins") { it { expect(row.runner_wins).to be(1) } }
    describe("#points") { it { expect(row.points).to be(8) } }
    describe("#weak_side_wins") { it { expect(row.weak_side_wins).to be(1) } }
    describe("#participation_points") { it { expect(row.participation_points).to be(4) } }

    context "with achievement" do
      let(:achievement) { create(:achievement, side: :corp, points: 3) }
      let!(:ea) do
        create(
          :earned_achievement,
          player: common_player,
          game: game1,
          achievement: achievement
        )
      end

      describe("#points") { it { expect(row.points).to eq(11) } }
      describe("#achievement_points") { it { expect(row.achievement_points).to eq(3) } }
    end
  end

  describe "#sorted_rows" do
    let(:sorted) { leaderboard.sorted_rows }

    it "correctly sorts rows" do
      expect(sorted.first.player).to be(common_player)
    end
  end
end
