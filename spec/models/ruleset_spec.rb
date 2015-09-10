RSpec.describe Ruleset, type: :model do
  let(:ruleset) { Ruleset.new }
  before do
    create(:rule, key: "points_for_participation", value: 3)
    create(:rule, key: "max_points_for_participation", value: 5)
  end

  describe "#points_for_participation" do
    context "full amount" do
      it do
        expect(ruleset.points_for_participation(0)).to eq(3)
      end
    end

    context "partial" do
      it do
        expect(ruleset.points_for_participation(3)).to eq(2)
      end
    end

    context "none" do
      it do
        expect(ruleset.points_for_participation(5)).to eq(0)
      end
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

    before do
      create(:tiebreaker, tiebreaker: :most_points)
      create(:tiebreaker, tiebreaker: :fewest_played)
    end

    it "should apply complex stats for each tiebreaker" do
      expect(Ranker::MostPoints).to receive(:apply_stats).with(row)
      expect(Ranker::FewestPlayed).to receive(:apply_stats).with(row)

      ruleset.apply_stats(row)
    end
  end
end
