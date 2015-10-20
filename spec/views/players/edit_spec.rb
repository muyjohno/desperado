RSpec.describe "players/edit.html.haml", type: :view do
  before do
    assign(:player, create(:player, name: "Player Name", notes: "Player notes"))
  end

  it "should display player form" do
    render

    expect(rendered).to have_content(t(:edit_player))
    expect(rendered).to have_field("player[name]", with: "Player Name")
    expect(rendered).to have_field("player[notes]", with: "Player notes")
  end
end
