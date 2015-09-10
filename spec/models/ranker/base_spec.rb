RSpec.describe Ranker::Base, type: :model do
  subject { Ranker::Base }
  let(:row1) { instance_double(LeaderboardRow) }
  let(:row2) { instance_double(LeaderboardRow) }

  it "should rank neutrally" do
    expect(subject.compare(row1, row2)).to be(0)
    expect(subject.compare(row1, row1)).to be(0)
    expect(subject.compare(row2, row1)).to be(0)
  end

  it "should apply no extra stats" do
    expect do
      subject.apply_stats(row1)
    end.not_to change { row1 }
  end
end
