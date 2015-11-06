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

  it "should transform achievement with Markdown in description" do
    create(:achievement,
            title: "Markdown'd",
            description: "**Johno Rocks**")
    render

    xpath = "//div[contains(@class, 'description')]" \
            "/*/strong[contains(., 'Johno Rocks')]"
    expect(rendered).to have_xpath(xpath)
  end
end
