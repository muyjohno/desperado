RSpec.describe Ranker::FewestPlayed, type: :model do
  subject { Ranker::FewestPlayed }
  let(:row1) { instance_double(LeaderboardRow) }
  let(:row2) { instance_double(LeaderboardRow) }

  before do
    allow(row1).to receive(:played).and_return(5)
    allow(row2).to receive(:played).and_return(3)
  end

  it "should rank by fewest played" do
    expect(subject.compare(row1, row2)).to be(1)
    expect(subject.compare(row1, row1)).to be(0)
    expect(subject.compare(row2, row1)).to be(-1)
  end
end
