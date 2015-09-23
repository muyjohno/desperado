RSpec.describe "achievements/new.html.haml", type: :view do
  before do
    assign(:achievement, Achievement.new)
  end

  it "should display achievement form" do
    render

    expect(rendered).to have_content(t(:add_achievement))
    expect(rendered).to have_field("achievement[title]")
  end
end
