RSpec.describe LeaderboardHelper, type: :helper do
  describe "#participation_points_active?" do
    context "when points are awarded for participation" do
      before { create(:rule, key: :points_for_participation, value: 1) }

      it { expect(helper.participation_points_active?).to eq(true) }
    end

    context "when points are not awarded for participation" do
      it { expect(helper.participation_points_active?).to eq(false) }
    end
  end

  describe "#achievement_points_active?" do
    context "when achievements exist" do
      before { create(:achievement) }

      it { expect(helper.achievement_points_active?).to eq(true) }
    end

    context "when achievements do not exist" do
      it { expect(helper.achievement_points_active?).to eq(false) }
    end
  end

  describe "#strength_of_schedule_active?" do
    context "when SOS tiebreaker exists" do
      before { create(:tiebreaker, tiebreaker: :highest_strength_of_schedule) }

      it { expect(helper.strength_of_schedule_active?).to eq(true) }
    end

    context "when SOS tiebreaker does not exist" do
      it { expect(helper.strength_of_schedule_active?).to eq(false) }
    end
  end
end
