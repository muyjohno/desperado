RSpec.describe LeagueHelper, type: :helper do
  describe "#tab_class" do
    it "returns correct class for active tab" do
      expect(helper.tab_class(:current, :current)).to eq(:active)
    end

    it "returns correct class for inactive tab" do
      expect(helper.tab_class(:other, :current)).to eq(nil)
    end
  end

  describe "#theme_options" do
    it "returns options in the correct format" do
      expect(helper.theme_options).to include([t(:theme_default), "default"])
      expect(helper.theme_options).to include([t(:theme_classic), "classic"])
    end
  end
end
