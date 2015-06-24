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
end
