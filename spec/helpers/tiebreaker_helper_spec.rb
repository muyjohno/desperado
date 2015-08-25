RSpec.describe TiebreakerHelper, type: :helper do
  describe "#tiebreaker_options" do
    let(:options) { helper.tiebreaker_options }
    before do
      create(:tiebreaker, tiebreaker: :most_points)
    end

    it "returns correct options" do
      [:most_weak_side_wins, :fewest_played].each do |o|
        expect(options).to include([t(o), o.to_s])
      end
      expect(options).not_to include([t(:most_points), "most_points"])
    end
  end
end
