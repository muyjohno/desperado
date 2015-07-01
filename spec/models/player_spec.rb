RSpec.describe Player, type: :model do
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

  describe "game associations" do
    let(:opponent) { create(:player) }
    let(:game) { create(:game, corp: subject, runner: opponent) }
    let(:game2) { create(:game, runner: subject, corp: opponent) }

    before do
      game
      game2
    end

    it "returns corp game" do
      expect(subject.corp_games).to include(game)
      expect(subject.corp_games).not_to include(game2)
    end

    it "returns runner game" do
      expect(subject.runner_games).to include(game2)
      expect(subject.runner_games).not_to include(game)
    end

    it "returns all games" do
      expect(subject.games).to include(game)
      expect(subject.games).to include(game2)
    end
  end

  describe "achievement associations" do
    let(:achievement) { create(:achievement, side: :corp) }
    let(:game) { create(:game, corp: subject) }
    let(:earned_achievement) do
      create(
        :earned_achievement,
        player: subject,
        game: game,
        achievement: achievement
      )
    end

    before { earned_achievement }

    it "returns earned_achievement" do
      expect(subject.earned_achievements.count).to eq(1)
      expect(subject.earned_achievements.first).to eq(earned_achievement)
    end

    it "returns achievement" do
      expect(subject.achievements.count).to eq(1)
      expect(subject.achievements.first).to eq(achievement)
    end
  end
end
