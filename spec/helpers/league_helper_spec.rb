RSpec.describe LeagueHelper, type: :helper do
  describe "#tab_class" do
    it "returns correct class for active tab" do
      expect(helper.tab_class(:current, :current)).to eq(:active)
    end

    it "returns correct class for inactive tab" do
      expect(helper.tab_class(:other, :current)).to eq(nil)
    end
  end
end
