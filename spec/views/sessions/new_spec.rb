RSpec.describe "sessions/new.html.haml", type: :view do
  before do
    render
  end

  it "should display login form" do
    expect(rendered).to have_field("username")
    expect(rendered).to have_selector("input[value=\"#{t(:log_in)}\"]")
  end
end
