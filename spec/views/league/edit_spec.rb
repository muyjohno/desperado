RSpec.describe "league/edit.html.haml", type: :view do
  before do
    assign(:league, create(:league))
  end

  it "should display league form" do
    render

    expect(rendered).to have_content(t(:edit_league))
    expect(rendered).to have_field("league[name]", with: "League")
  end
end
