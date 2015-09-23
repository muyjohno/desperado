RSpec.describe "users/edit.html.haml", type: :view do
  before do
    assign(:user, create(:user))

    render
  end

  it "should display player form" do
    expect(rendered).to have_content(t(:change_password))
    expect(rendered).to have_field("user[password]")
  end
end
