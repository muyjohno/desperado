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

    describe "dependence" do
      let!(:dependent_game) { create(:game) }

      it "destroys associated games" do
        expect do
          dependent_game.corp.destroy!
        end.to change(Game, :count).by(-1)
      end
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

    describe "dependence" do
      let!(:earned) { create_earned_achievement }

      it "earned achievement is deleted" do
        expect do
          earned.player.destroy
        end.to change(EarnedAchievement, :count).by(-1)
      end
    end
  end

  describe "#earned?" do
    let(:earned) { create_earned_achievement }
    let(:unearned) { create(:achievement) }
    let(:player) { earned.player }

    it "returns correct values" do
      expect(player.earned?(earned.achievement)).to eq(true)
      expect(player.earned?(unearned)).to eq(false)
    end
  end

  describe "order" do
    let!(:alan) { create(:player, name: "Alan") }
    let!(:zuzanna) { create(:player, name: "Zuzanna") }
    let!(:brian) { create(:player, name: "Brian") }
    let(:all) { Player.all }

    it "defaults order to alphabetical by name" do
      expect(all.first).to eq(alan)
      expect(all.second).to eq(brian)
      expect(all.last).to eq(zuzanna)
    end
  end
end
