RSpec.describe EarnedAchievement, type: :model do
  let(:player) { create(:player) }
  let(:achievement) { create(:achievement, side: :corp) }
  let(:game) { create(:game, corp: player) }
  let(:subject) do
    create(
      :earned_achievement,
      player: player,
      game: game,
      achievement: achievement
    )
  end

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
  end
end
