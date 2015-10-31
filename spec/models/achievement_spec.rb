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

  describe "to_s" do
    it "is well-formed" do
      subject.side = "corp"
      subject.title = "Membrane"
      subject.points = 2
      subject.description = "Whatever"

      expect(subject.to_s).to eq "Achievement [corp/2] 'Membrane' / 'Whatever'"
    end
  end

  describe "player associations" do
    let(:player) { create(:player) }
    let(:game) { create(:game, subject.side.to_s => player) }
    let(:earned_achievement) do
      create(
        :earned_achievement,
        player: player,
        game: game,
        achievement: subject
      )
    end

    before { earned_achievement }

    it "returns earned_achievement" do
      expect(subject.earned_achievements.count).to eq(1)
      expect(subject.earned_achievements.first).to eq(earned_achievement)
    end

    it "returns earner" do
      expect(subject.earners.count).to eq(1)
      expect(subject.earners.first).to eq(player)
    end
  end

  describe "dependence" do
    let!(:earned) { create_earned_achievement }

    it "earned achievement is deleted" do
      expect do
        earned.achievement.destroy
      end.to change(EarnedAchievement, :count).by(-1)
    end
  end
end
