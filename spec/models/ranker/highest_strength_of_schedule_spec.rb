RSpec.describe Ranker::HighestStrengthOfSchedule, type: :model do
  subject { Ranker::HighestStrengthOfSchedule }
  create_sample_league

  before do
    create(:tiebreaker, tiebreaker: :highest_strength_of_schedule)
  end

  it "should contain special data about strength of schedule" do
    expect(adam_row.sos).to eq(68)
    expect(ben_row.sos).to eq(56)
    expect(chuck_row.sos).to eq(52)
  end

  it "should rank by sos" do
    expect(subject.compare(adam_row, ben_row)).to be(-1)
    expect(subject.compare(adam_row, adam_row)).to be(0)
    expect(subject.compare(ben_row, adam_row)).to be(1)
  end
end
