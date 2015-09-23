RSpec.describe "games/new.html.haml", type: :view do
  before do
    assign(:game, Game.new)

    render
  end

  it "should display game form" do
    expect(rendered).to have_content(t(:add_game))
    expect(rendered).to have_field("game[result]")
  end

  it "should display reverse form" do
    expect(rendered).to have_content(t(:add_game_reverse_instruction))
    expect(rendered).to have_field("reverse_result")
  end
end
