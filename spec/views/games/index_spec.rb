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

  context "with bye" do
    before do
      create(:game, corp: geoff, runner_id: nil, result: :bye)

      assign(:games, Game.all)
    end

    it "should display bye message" do
      render

      expect(rendered).to have_content(t(:bye))
    end
  end
end
