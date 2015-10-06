RSpec.describe Leaderboard, type: :model do
  create_sample_league

  it "should build correct leaderboard" do
    expect(leaderboard.rows.count).to be(3)
  end

  context "row" do
    let(:row) { leaderboard.row_for(adam) }

    it "handles invalid player" do
      expect(leaderboard.row_for(create(:player))).to be_a(Null::LeaderboardRow)
    end

    describe("#played") { it { expect(row.played).to be(8) } }
    describe("#corp_wins") { it { expect(row.corp_wins).to be(1) } }
    describe("#runner_wins") { it { expect(row.runner_wins).to be(1) } }
    describe("#points") { it { expect(row.points).to be(13) } }
    describe("#weak_side_wins") { it { expect(row.weak_side_wins).to be(1) } }
    describe("#participation_points") do
      it { expect(row.participation_points).to be(8) }
    end
    describe("#result_points") { it { expect(row.result_points).to be(5) } }
    describe("#byes") { it { expect(row.byes).to be(0) } }
    describe("#games") do
      it { expect(row.games.count).to be(8) }
      it { expect(row.games).to include(game1) }
      it { expect(row.games).not_to include(game5) }
    end

    context "with achievement" do
      let(:achievement) { create(:achievement, side: :corp, points: 3) }
      let!(:ea) do
        create(
          :earned_achievement,
          player: adam,
          game: game1,
          achievement: achievement
        )
      end

      describe("#points") { it { expect(row.points).to eq(16) } }
      describe("#achievement_points") do
        it { expect(row.achievement_points).to eq(3) }
      end
    end

    context "with special tiebreaker stats" do
      it "should apply special stats to each row" do
        expect(default_ruleset).to receive(:apply_stats).exactly(3).times

        leaderboard.rows
      end

      it "should be able to set and get custom stats" do
        row.test = 99

        expect(row.test).to eq(99)
      end

      it "should correctly raise error if key doesn't exist" do
        expect do
          row.this_doesnt_exist
        end.to raise_error(NoMethodError)
      end
    end
  end

  describe "#sorted_rows" do
    let(:sorted) { leaderboard.sorted_rows }

    it "correctly sorts rows" do
      expect(sorted.first.player).to be(chuck)
    end
  end

  context "with bye" do
    before do
      create(:game, corp: adam, runner_id: nil, result: :bye)
      create(:rule, key: :points_for_bye, value: 5)
      games
    end

    let(:leaderboard) { create_leaderboard(games: Game.all) }
    let(:row) { leaderboard.row_for(adam) }

    describe("#byes") { it { expect(row.byes).to be(1) } }
    describe("#points") { it { expect(row.points).to be(19) } }
  end
end
