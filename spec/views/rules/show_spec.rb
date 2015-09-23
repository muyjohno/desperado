RSpec.describe "rules/show.html.haml", type: :view do
  before do
    assign(:content, "This is the rules content")

    render
  end

  it "should display content" do
    expect(rendered).to have_content(t(:rules))
    expect(rendered).to have_content("This is the rules content")
  end
end
