RSpec.describe Ruleset, type: :model do
  let(:ruleset) { Ruleset.new }
  before do
    create(:rule, key: "points_for_participation", value: 3)
    create(:rule, key: "max_points_for_participation", value: 5)
  end

  describe "#points_for" do
    let(:game) { double("game") }
    let(:row) { double("row") }
    let(:calculator) { double("Points::Result.new") }

    before do
      allow(Points::Result).to receive(:new).and_return(calculator)
    end

    it "should instantiate and use correct points calculator" do
      expect(calculator).to receive(:calculate).with(game, row)

      ruleset.points_for(:result, game, row)
    end
  end

  describe "#rankers" do
    let(:rankers) { ruleset.rankers }

    before do
      create(:tiebreaker, tiebreaker: :most_weak_side_wins, ordinal: 2)
      create(:tiebreaker, tiebreaker: :most_points, ordinal: 1)
      create(:tiebreaker, tiebreaker: :fewest_played, ordinal: 3)
    end

    it "returns rankers in order" do
      expect(rankers.length).to eq(3)
      expect(rankers.first).to eq(Ranker::MostPoints)
      expect(rankers.second).to eq(Ranker::MostWeakSideWins)
      expect(rankers.third).to eq(Ranker::FewestPlayed)
    end
  end

  describe "#apply_stats" do
    let(:player) { create(:player) }
    let(:row) { LeaderboardRow.new(player, ruleset) }
    let(:all_rows) { double("Collection of Leaderboard Rows") }

    before do
      create(:tiebreaker, tiebreaker: :most_points)
      create(:tiebreaker, tiebreaker: :fewest_played)
    end

    it "should apply complex stats for each tiebreaker" do
      expect(Ranker::MostPoints).to receive(:apply_stats).
        with(row, all_rows, ruleset)
      expect(Ranker::FewestPlayed).to receive(:apply_stats).
        with(row, all_rows, ruleset)

      ruleset.apply_stats(row, all_rows)
    end
  end
end
