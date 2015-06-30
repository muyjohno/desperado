RSpec.describe Achievement, type: :model do
  let(:subject) { create(:achievement) }

  context "when valid" do
    it do
      expect(subject).to be_valid
    end

    it "description is optional" do
      subject.description = nil

      expect(subject).to be_valid
    end
  end

  context "when invalid" do
    context "without title" do
      it do
        subject.title = nil

        expect(subject).not_to be_valid
      end
    end

    context "without side" do
      it do
        subject.side = nil

        expect(subject).not_to be_valid
      end
    end

    context "without points" do
      it do
        subject.points = nil

        expect(subject).not_to be_valid
      end
    end
  end
end
