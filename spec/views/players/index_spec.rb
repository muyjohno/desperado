RSpec.describe "players/index.html.haml", type: :view do
  before do
    3.times { create(:player, name: "Player Name") }
    assign(:players, Player.all)

    render
  end

  it "should display player list" do
    expect(rendered).to have_content(t(:players))
    expect(rendered).to have_css("tr", count: 4)
    expect(rendered).to have_content("Player Name", count: 3)
  end
end
