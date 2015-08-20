RSpec.describe Rule, type: :model do
  let(:rule) { create(:rule) }

  describe "validation" do
    context "valid" do
      it { expect(rule).to be_valid }
    end

    context "duplicate key" do
      let(:duplicate) { Rule.new(key: rule.key) }

      it { expect(duplicate).not_to be_valid }
    end
  end

  it "should fall back to default" do
    expect(Rule.value_for("doesn't exist", 99)).to eq(99)
  end
end
