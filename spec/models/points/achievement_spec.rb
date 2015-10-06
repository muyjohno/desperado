RSpec.describe Points::Achievement, type: :model do
  create_sample_league
  subject { Points::Achievement.new }
  let(:achievement) { create(:achievement, side: :corp, points: 2) }
  let(:earned) do
    build(:earned_achievement, player: adam, achievement: achievement)
  end

  before do
    game1.earned_achievements << earned
  end

  it { expect(subject.calculate(game1, adam_row)).to eq(2) }
end
