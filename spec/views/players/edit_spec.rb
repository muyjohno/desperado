RSpec.describe "players/edit.html.haml", type: :view do
  before do
    assign(:player, create(:player, name: "Player Name"))
  end

  it "should display player form" do
    render

    expect(rendered).to have_content(t(:edit_player))
    expect(rendered).to have_field("player[name]", with: "Player Name")
  end
end
