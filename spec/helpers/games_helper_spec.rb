RSpec.describe GamesHelper, type: :helper do
  it "gets result options" do
    expect(helper.result_options).to eq([
      [t(:corp_win).titleize, "corp_win"],
      [t(:runner_win).titleize, "runner_win"],
      [t(:corp_time_win).titleize, "corp_time_win"],
      [t(:runner_time_win).titleize, "runner_time_win"],
      [t(:tie).titleize, "tie"],
      [t(:bye).titleize, "bye"]
    ])
  end

  describe "achievements" do
    let!(:corp_achievement) { create(:achievement, side: :corp) }
    let!(:runner_achievement) { create(:achievement, side: :runner) }

    describe "#corp_achievements" do
      it { expect(helper.corp_achievements).to include(corp_achievement) }
      it { expect(helper.corp_achievements).not_to include(runner_achievement) }
    end

    describe "#runner_achievements" do
      it { expect(helper.runner_achievements).to include(runner_achievement) }
      it { expect(helper.runner_achievements).not_to include(corp_achievement) }
    end
  end

  describe "#result_class" do
    let(:game) { create(:game, corp: player, result: :corp_win) }
    let(:player) { create(:player) }

    it "returns correct class" do
      expect(helper.result_class(game, player)).to eq(:win)
    end
  end

  describe "game descriptions" do
    let(:game) { create(:game, corp: jim, runner: bob) }
    let(:jim) { create(:player, name: "Jim") }
    let(:bob) { create(:player, name: "Bob") }

    describe "#played_side_against_opponent" do
      it "returns correct description" do
        expect(helper.played_side_against_opponent(game, jim))
          .to eq("Played Corp against <a href=\"/players/#{bob.to_param}\">Bob</a>:")
      end

      context "bye" do
        let(:game) { create(:game, result: :bye, corp: jim, runner: nil) }

        it "returns correct description" do
          expect(helper.played_side_against_opponent(game, jim)).to eq("<a href=\"/players/#{jim.to_param}\">Jim</a> had a bye")
        end
      end
    end

    describe "#neutral_game_title" do
      it "returns correct description" do
        expect(helper.neutral_game_title(game))
          .to eq("<a href=\"/players/#{jim.to_param}\">Jim</a> (Corp) played <a href=\"/players/#{bob.to_param}\">Bob</a> (Runner): Jim Win")
      end

      context "bye" do
        let(:game) { create(:game, result: :bye, corp: jim, runner: nil) }

        it "returns correct description" do
          expect(helper.neutral_game_title(game)).to eq("<a href=\"/players/#{jim.to_param}\">Jim</a> had a bye")
        end
      end
    end

    describe "#neutral_result" do
      context "tie" do
        before { game.result = :tie }

        it { expect(helper.neutral_result(game)).to eq("Tie") }
      end

      context "corp_win" do
        before { game.result = :corp_win }

        it { expect(helper.neutral_result(game)).to eq("Jim Win") }
      end
      context "runner_win" do
        before { game.result = :runner_win }

        it { expect(helper.neutral_result(game)).to eq("Bob Win") }
      end
      context "corp_time_win" do
        before { game.result = :corp_time_win }

        it { expect(helper.neutral_result(game)).to eq("Jim Time win") }
      end
    end
  end

  describe "#link_player" do
    let(:player) { create(:player, name: "Player") }

    it "returns correct link" do
      expect(helper.link_player(player)).to eq("<a href=\"/players/#{player.to_param}\">Player</a>")
    end
  end
end
