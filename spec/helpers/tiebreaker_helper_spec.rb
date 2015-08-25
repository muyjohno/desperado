RSpec.describe TiebreakerHelper, type: :helper do
  describe "#tiebreaker_options" do
    before do
      create(:tiebreaker, tiebreaker: :most_points)
    end

    it "returns correct options" do
      expect(helper.tiebreaker_options).to include([t(:most_weak_side_wins), "most_weak_side_wins"])
      expect(helper.tiebreaker_options).to include([t(:fewest_played), "fewest_played"])
      expect(helper.tiebreaker_options).not_to include([t(:most_points), "most_points"])
    end
  end
end
