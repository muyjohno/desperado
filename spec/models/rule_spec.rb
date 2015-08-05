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
end
