RSpec.describe Tiebreaker, type: :model do
  describe "validation" do
    let(:tiebreaker) { build(:tiebreaker, tiebreaker: :most_points) }

    it "should be valid" do
      expect(tiebreaker).to be_valid
    end

    context "invalid" do
      it "should have unique tiebreaker" do
        create(:tiebreaker, tiebreaker: :most_points)

        expect(tiebreaker).not_to be_valid
      end
    end
  end

  describe ".ordered" do
    let!(:second) { create(:tiebreaker, tiebreaker: :most_weak_side_wins, ordinal: 2) }
    let!(:first) { create(:tiebreaker, tiebreaker: :most_points, ordinal: 1) }
    let(:ordered) { Tiebreaker.ordered }

    it "should return tiebreakers in order" do
      expect(ordered.first).to eq(first)
      expect(ordered.second).to eq(second)
    end
  end
end
