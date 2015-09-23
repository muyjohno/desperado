RSpec.describe "games/index.html.haml", type: :view do
  let(:geoff) { create(:player, name: "Geoff") }

  before do
    3.times { create(:game, corp: geoff) }
    assign(:games, Game.all)
  end

  it "should display game list" do
    render

    expect(rendered).to have_content(t(:games))
    expect(rendered).to have_css("tr", count: 4)
    expect(rendered).to have_content("Geoff", count: 3)
  end
end
