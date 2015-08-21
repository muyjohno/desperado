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
end
