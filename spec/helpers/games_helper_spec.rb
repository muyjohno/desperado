RSpec.describe GamesHelper, type: :helper do
  it "gets result options" do
    expect(helper.result_options).to eq([
      [t(:corp_win).titleize, "corp_win"],
      [t(:runner_win).titleize, "runner_win"],
      [t(:corp_time_win).titleize, "corp_time_win"],
      [t(:runner_time_win).titleize, "runner_time_win"],
      [t(:tie).titleize, "tie"]
    ])
  end

  describe "achievements" do
    let!(:corp_achievement) { create(:achievement, side: :corp) }
    let!(:runner_achievement) { create(:achievement, side: :runner) }

    describe "#corp_achievements" do
      it { expect(helper.corp_achievements).to include(corp_achievement) }
      it { expect(helper.corp_achievements).not_to include(runner_achievement) }
    end

    describe "#runner_achievements" do
      it { expect(helper.runner_achievements).to include(runner_achievement) }
      it { expect(helper.runner_achievements).not_to include(corp_achievement) }
    end
  end
end
