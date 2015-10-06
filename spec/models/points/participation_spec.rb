RSpec.describe Points::Participation, type: :model do
  create_sample_league
  subject { Points::Participation.new }

  before do
    Rule.find_by_key(:points_for_participation).update!(value: 5)
  end

  let(:leaderboard) { create_leaderboard(games: []) }

  context "full amount" do
    it { expect(subject.calculate(game1, adam_row)).to eq(5) }
  end

  context "limited by max" do
    before do
      create(:rule, key: :max_points_for_participation, value: 8)
    end

    it { expect(subject.calculate(game1, adam_row)).to eq(5) }

    context "some games played" do
      let(:leaderboard) { create_leaderboard(games: [game1]) }

      it { expect(subject.calculate(game2, adam_row)).to eq(3) }
    end

    context "at max" do
      let(:leaderboard) { create_leaderboard(games: [game1, game2]) }

      it { expect(subject.calculate(game3, adam_row)).to eq(0) }
    end
  end

  context "limited by weekly max" do
    before do
      create(:rule, key: :max_points_for_participation_per_week, value: 7)
    end

    it { expect(subject.calculate(game1, adam_row)).to eq(5) }

    context "some games played" do
      let(:leaderboard) { create_leaderboard(games: [game1, game2]) }

      it { expect(subject.calculate(game2, adam_row)).to eq(2) }
    end

    context "at max" do
      let(:leaderboard) { create_leaderboard(games: [game1, game2, game3]) }

      it { expect(subject.calculate(game3, adam_row)).to eq(0) }
    end

    context "subsequent week" do
      let(:leaderboard) do
        create_leaderboard(games: [game1, game2, new_week_game])
      end
      let(:new_week_game) { create(:game, corp: adam, runner: ben, week: 2) }

      it { expect(subject.calculate(new_week_game, adam_row)).to eq(5) }
    end
  end
end
