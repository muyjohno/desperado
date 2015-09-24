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
    let(:unrelated) { create(:player) }

    context "corp win" do
      before { game.result = :corp_win }

      it "returns correct results" do
        expect(game.player_result(corp)).to be(:win)
        expect(game.player_result(runner)).to be(:loss)
      end

      it "unrelated player returns nil" do
        expect(game.player_result(unrelated)).to be(nil)
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

    context "bye" do
      before do
        game.result = :bye
        game.runner = nil
      end

      it "returns correct results" do
        expect(game.player_result(corp)).to be(:bye)
        expect(game.player_result(runner)).to be(nil)
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
      expect do
        subject.add_achievement(achievement)
      end.to change { subject.earned_achievements.count }.by(1)

      expect(subject.earned_achievements.first.achievement).to eq(achievement)
      expect(subject.earned_achievements.first.player).to eq(subject.corp)
      expect(subject.earned_achievements.first.game).to eq(subject)
    end
  end

  describe "#remove_achievement" do
    let(:earned_achievement) { create_earned_achievement }

    it "removes achievement from game" do
      expect do
        earned_achievement.game
          .remove_achievement(earned_achievement.achievement)
      end.to change { earned_achievement.game.earned_achievements.count }.by(-1)

      expect(EarnedAchievement.where(
        achievement: earned_achievement.achievement,
        game: earned_achievement.game
      ).count).to eq(0)
    end
  end

  describe "dependence" do
    let!(:earned) { create_earned_achievement }

    it "earned achievement is deleted" do
      expect do
        earned.game.destroy
      end.to change(EarnedAchievement, :count).by(-1)
    end
  end

  describe "#points_for_achievements" do
    let(:jim) { create(:player) }
    let(:bob) { create(:player) }
    let(:game) { create(:game, corp: jim, runner: bob) }
    let(:ach1) { create(:achievement, side: :corp, points: 2) }
    let(:ach2) { create(:achievement, side: :runner, points: 1) }
    let(:ach3) { create(:achievement, side: :corp, points: 3) }
    let!(:ea1) do
      create(:earned_achievement, achievement: ach1, player: jim, game: game)
    end
    let!(:ea2) do
      create(:earned_achievement, achievement: ach2, player: bob, game: game)
    end
    let!(:ea3) do
      create(:earned_achievement, achievement: ach3, player: jim, game: game)
    end

    it "returns total of earned achievements" do
      expect(game.points_for_achievements(jim)).to eq(5)
      expect(game.points_for_achievements(bob)).to eq(1)
    end
  end

  describe "#opponent" do
    let(:game) { create(:game) }
    let(:unrelated_player) { create(:player) }

    it "gets runner" do
      expect(game.opponent(game.corp)).to eq(game.runner)
    end

    it "gets corp" do
      expect(game.opponent(game.runner)).to eq(game.corp)
    end

    it "fails correctly" do
      expect(game.opponent(unrelated_player)).to be_a(Null::Player)
    end
  end

  describe "#player_achievements" do
    let(:earned_achievement) { create_earned_achievement }
    let(:game) { earned_achievement.game }
    let(:player) { earned_achievement.player }

    it "returns achievements" do
      expect(game.achievements(player).count).to eq(1)
      expect(game.achievements(player)).to include(earned_achievement.achievement)
    end
  end

  describe "#winner" do
    let(:game) { create(:game) }
    let(:unrelated_player) { create(:player) }

    it "gets runner" do
      game.result = :runner_win

      expect(game.winner).to eq(game.runner)
    end

    it "gets corp" do
      game.result = :corp_time_win

      expect(game.winner).to eq(game.corp)
    end

    it "fails correctly" do
      game.result = :tie

      expect(game.winner).to be_a(Null::Player)
    end
  end

  describe ".recent" do
    let!(:games) do
      [].tap do |games|
        11.times do
          games << create(:game, week: 2)
        end
        games << create(:game, week: 1)
      end
    end
    let(:recent) { Game.recent }

    it "returns correct number" do
      expect(Game.recent.count).to eq(10)
    end

    it "returns correct games" do
      games.each_with_index do |game, i|
        if i == 0 || i == 11
          expect(recent).not_to include(game)
        else
          expect(recent).to include(game)
        end
      end
    end
  end

  describe "byes" do
    let(:player) { create(:player) }
    let(:game) { create(:game, corp: player, runner: nil, result: :bye) }

    it { expect(game).to be_valid }

    describe "validation" do
      context "no players" do
        before do
          game.corp = nil
        end

        it "shouldn't be valid" do
          expect(game).not_to be_valid
          expect(game.errors[:result]).not_to be_empty
        end
      end

      context "two players" do
        before do
          game.runner = create(:player)
        end

        it "shouldn't be valid" do
          expect(game).not_to be_valid
          expect(game.errors[:result]).not_to be_empty
        end
      end
    end

    describe "#bye_player" do
      it "should return correct player" do
        expect(game.bye_player).to be(player)
      end
    end
  end

  context "nil player" do
    let(:corpless) { build(:game, corp_id: nil) }
    let(:runnerless) { build(:game, runner_id: nil) }

    it "should return Null::Player corp" do
      expect(corpless.corp_player).to be_a(Null::Player)
    end

    it "should return Null::Player runner" do
      expect(runnerless.runner_player).to be_a(Null::Player)
    end
  end
end
