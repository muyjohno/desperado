RSpec.describe Game, type: :model do
  let(:subject) { create(:game) }

  context "when valid" do
    it do
      expect(subject).to be_valid
    end
  end

  context "when invalid" do
    context "without corp" do
      it do
        subject.corp = nil

        expect(subject).not_to be_valid
      end
    end

    context "without runner" do
      it do
        subject.runner = nil

        expect(subject).not_to be_valid
      end
    end

    context "without result" do
      it do
        subject.result = nil

        expect(subject).not_to be_valid
      end
    end

    context "with same player on both sides" do
      it do
        player = create(:player)
        subject.corp = player
        subject.runner = player

        expect(subject).not_to be_valid
      end
    end
  end

  describe "player associations" do
    let(:corp_player) { create(:player) }
    let(:runner_player) { create(:player) }
    let(:game_with_associations) do
      create(:game, runner: runner_player, corp: corp_player)
    end

    it "returns corp player" do
      expect(game_with_associations.corp).to eq(corp_player)
    end

    it "returns runner player" do
      expect(game_with_associations.runner).to eq(runner_player)
    end
  end

  describe "result" do
    let(:corp) { create(:player) }
    let(:runner) { create(:player) }
    let(:game) { create(:game, runner: runner, corp: corp) }

    context "corp win" do
      before { game.result = :corp_win }

      it "returns correct results" do
        expect(game.player_result(corp)).to be(:win)
        expect(game.player_result(runner)).to be(:loss)
      end
    end

    context "runner win" do
      before { game.result = :runner_win }

      it "returns correct results" do
        expect(game.player_result(corp)).to be(:loss)
        expect(game.player_result(runner)).to be(:win)
      end
    end

    context "corp time win" do
      before { game.result = :corp_time_win }

      it "returns correct results" do
        expect(game.player_result(corp)).to be(:time_win)
        expect(game.player_result(runner)).to be(:loss)
      end
    end

    context "runner time win" do
      before { game.result = :runner_time_win }

      it "returns correct results" do
        expect(game.player_result(corp)).to be(:loss)
        expect(game.player_result(runner)).to be(:time_win)
      end
    end

    context "tie" do
      before { game.result = :tie }

      it "returns correct results" do
        expect(game.player_result(corp)).to be(:tie)
        expect(game.player_result(runner)).to be(:tie)
      end
    end
  end

  describe "achievement associations" do
    let(:achievement) { create(:achievement, side: :corp) }
    let!(:earned_achievement) do
      create(
        :earned_achievement,
        game: subject,
        achievement: achievement,
        player: subject.corp
      )
    end

    it "returns earned_achievement" do
      expect(subject.earned_achievements.count).to eq(1)
      expect(subject.earned_achievements.first).to eq(earned_achievement)
    end

    it "returns achievement" do
      expect(subject.achievements.count).to eq(1)
      expect(subject.achievements.first).to eq(achievement)
    end
  end

  describe "#add_achievement" do
    let(:achievement) { create(:achievement, side: :corp) }

    it "adds achievement to game" do
      subject.add_achievement(achievement)

      expect(subject.earned_achievements.count).to eq(1)
      expect(subject.earned_achievements.first.achievement).to eq(achievement)
      expect(subject.earned_achievements.first.player).to eq(subject.corp)
      expect(subject.earned_achievements.first.game).to eq(subject)
    end
  end
end
