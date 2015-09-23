RSpec.describe "league/rules.html.haml", type: :view do
  let(:league) { create(:league) }

  before do
    create(:rule, key: :points_for_win, value: 9, league: league)
    assign(:league, league)
    assign(:rules, league.all_rules)
  end

  it "should display league rules form" do
    render

    expect(rendered).to have_content(t(:edit_rules))
    expect(rendered).to have_field("rules[points_for_win]", with: "9")
  end
end
