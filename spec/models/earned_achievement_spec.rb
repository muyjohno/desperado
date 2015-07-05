RSpec.describe EarnedAchievement, type: :model do
  let!(:subject) { create_earned_achievement }

  context "when valid" do
    it do
      expect(subject).to be_valid
    end
  end

  context "when invalid" do
    context "without player" do
      it do
        subject.player = nil

        expect(subject).not_to be_valid
      end
    end

    context "without game" do
      it do
        subject.game = nil

        expect(subject).not_to be_valid
      end
    end

    context "without achievement" do
      it do
        subject.achievement = nil

        expect(subject).not_to be_valid
      end
    end

    context "without integrity" do
      it do
        subject.player = create(:player)

        expect(subject).not_to be_valid
      end
    end

    context "duplicate" do
      let(:duplicate) do
        EarnedAchievement.new(
          player: subject.player,
          achievement: subject.achievement,
          game: subject.game
        )
      end

      it { expect(duplicate).not_to be_valid }
    end
  end
end
