RSpec.describe AchievementsHelper, type: :helper do
  it "gets side options" do
    expect(helper.side_options).to eq([
      [t(:corp).titleize, "corp"],
      [t(:runner).titleize, "runner"]
    ])
  end

  describe "#achievement_class" do
    let!(:ach) { create(:achievement) }
    let!(:ea) { create_earned_achievement }

    context "no player" do
      it "returns default class" do
        expect(helper.achievement_class(ach, nil)).to eq("panel-info")
      end
    end

    context "with player" do
      context "with earned achievement" do
        it "returns correct class" do
          expect(helper.achievement_class(ea.achievement, ea.player)).to eq("panel-success")
        end
      end

      context "with unearned achievement" do
        it "returns correct class" do
          expect(helper.achievement_class(ach, ea.player)).to eq(nil)
        end
      end
    end
  end
end
