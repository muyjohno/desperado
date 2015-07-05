RSpec.describe Rules::PointFactory, type: :model do
  subject { Rules::PointFactory }

  context "win" do
    before do
      create(:rule, key: :points_for_win, value: 5)
    end

    it "gets correct value" do
      expect(subject.points_for_result(:win)).to eq(5)
    end
  end

  context "time_win" do
    before do
      create(:rule, key: :points_for_time_win, value: 4)
    end

    it "gets correct value" do
      expect(subject.points_for_result(:time_win)).to eq(4)
    end
  end

  context "tie" do
    before do
      create(:rule, key: :points_for_tie, value: 3)
    end

    it "gets correct value" do
      expect(subject.points_for_result(:tie)).to eq(3)
    end
  end

  context "loss" do
    before do
      create(:rule, key: :points_for_loss, value: 2)
    end

    it "gets correct value" do
      expect(subject.points_for_result(:loss)).to eq(2)
    end
  end
end
