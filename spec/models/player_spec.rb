RSpec.describe Player do
  let(:subject) { create(:player) }

  context "when valid" do
    it do
      expect(subject).to be_valid
    end
  end

  context "when invalid" do
    context "with invalid name" do
      it do
        subject.name = nil

        expect(subject).not_to be_valid
      end
    end
  end
end
