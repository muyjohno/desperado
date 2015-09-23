RSpec.describe "achievements/index.html.haml", type: :view do
  before do
    3.times { create(:achievement, title: "Achievement Title") }
    assign(:achievements, Achievement.all)
  end

  it "should display achievement grid" do
    render

    expect(rendered).to have_content(t(:achievements))
    expect(rendered).to have_css(".achievement", count: 3)
    expect(rendered).to have_content("Achievement Title", count: 3)
  end
end
