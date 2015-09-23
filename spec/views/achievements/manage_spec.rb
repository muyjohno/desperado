RSpec.describe "achievements/manage.html.haml", type: :view do
  before do
    3.times { create(:achievement, title: "Achievement Title") }
    assign(:achievements, Achievement.all)
  end

  it "should display achievement table" do
    render

    expect(rendered).to have_content(t(:achievements))
    expect(rendered).to have_css("tr", count: 4)
    expect(rendered).to have_content("Achievement Title", count: 3)
  end
end
