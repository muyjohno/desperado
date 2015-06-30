RSpec.describe AchievementsHelper, type: :helper do
  it "gets side options" do
    expect(helper.side_options).to eq([
      [t(:corp).titleize, "corp"],
      [t(:runner).titleize, "runner"]
    ])
  end
end
