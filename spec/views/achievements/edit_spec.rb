RSpec.describe "achievements/edit.html.haml", type: :view do
  before do
    assign(:achievement, create(:achievement))
  end

  it "should display achievement form" do
    render

    expect(rendered).to have_content(t(:edit_achievement))
    expect(rendered).to have_field("achievement[title]", with: "Achievement")
  end
end
