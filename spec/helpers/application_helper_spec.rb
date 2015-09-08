RSpec.describe ApplicationHelper, type: :helper do
  describe "#theme" do
    context "league has a theme" do
      before do
        League.current.update(theme: :default)
      end

      it "returns theme" do
        expect(helper.theme).to eq("default")
      end
    end

    context "league has no theme" do
      before do
        League.current.update(theme: nil)
      end

      it "returns default" do
        expect(helper.theme).to eq("default")
      end
    end
  end
end
