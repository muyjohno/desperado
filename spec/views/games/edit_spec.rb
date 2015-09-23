RSpec.describe "games/edit.html.haml", type: :view do
  before do
    assign(:game, create(:game))

    render
  end

  it "should display game form" do
    expect(rendered).to have_content(t(:edit_game))
    expect(rendered).to have_field("game[result]", with: "corp_win")
  end

  it "should not display reverse form" do
    expect(rendered).not_to have_content(t(:add_game_reverse_instruction))
    expect(rendered).not_to have_field("reverse_result")
  end
end
