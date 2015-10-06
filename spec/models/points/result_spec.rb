RSpec.describe Points::Result, type: :model do
  create_sample_league
  subject { Points::Result.new }

  context "win" do
    it { expect(subject.calculate(game1, adam_row)).to eq(2) }
  end

  context "loss" do
    it { expect(subject.calculate(game1, ben_row)).to eq(0) }
  end

  context "tie" do
    it { expect(subject.calculate(game9, adam_row)).to eq(1) }
  end

  context "corp time win" do
    it { expect(subject.calculate(game5, ben_row)).to eq(1) }
  end

  context "runner time win" do
    it { expect(subject.calculate(game11, chuck_row)).to eq(1) }
  end

  context "bye" do
    before do
      create(:rule, key: :points_for_bye, value: 9)
    end

    let(:game) { create(:game, corp: adam, runner: nil, result: :bye) }

    it { expect(subject.calculate(game, adam_row)).to eq(9) }
  end
end
