RSpec.describe Leaderboard, type: :model do
  let(:common_player) { create(:player) }
  let(:game1) { create(:game, corp: common_player, result: :corp_win) }
  let(:game2) { create(:game, runner: common_player, result: :runner_win) }
  let(:leaderboard) { Leaderboard.new([game1, game2]) }

  it "should build correct leaderboard" do
    expect(leaderboard.rows.count).to be(3)
  end

  context "row" do
    let(:row) { leaderboard.rows[common_player.id] }

    describe("#played") { it { expect(row.played).to be(2) } }
    describe("#corp_wins") { it { expect(row.corp_wins).to be(1) } }
    describe("#runner_wins") { it { expect(row.runner_wins).to be(1) } }
    describe("#points") { it { expect(row.points).to be(4) } }
  end

  describe "#sorted_rows" do
    let(:sorted) { leaderboard.sorted_rows }

    it "correctly sorts rows" do
      expect(sorted.first.player).to be(common_player)
    end
  end
end
