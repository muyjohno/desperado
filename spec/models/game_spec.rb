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
end
