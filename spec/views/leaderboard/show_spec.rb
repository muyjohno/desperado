RSpec.describe "leaderboard/show.html.haml", type: :view do
  create_sample_league

  context "league under way" do
    before do
      assign(:content, "Custom page content")
      assign(:leaderboard, leaderboard.sorted_rows)
      assign(:recent_games, Game.recent)

      render
    end

    it "should display page content" do
      expect(rendered).to have_content("Custom page content")
    end

    it "should display leaderboard" do
      expect(rendered).to have_content(t(:leaderboard_position))
      expect(rendered).to have_content("Chuck")
      expect(rendered).to have_content("3/1")
    end

    it "should display recent games" do
      expect(rendered).to have_content(
        "Chuck (Corp) played Ben (Runner): Chuck Win"
      )
    end
  end

  context "no games" do
    before do
      assign(:content, "Custom page content")
      assign(:leaderboard, [])
      assign(:recent_games, [])

      render
    end

    it "should display page content" do
      expect(rendered).to have_content("Custom page content")
    end

    it "should not display leaderboard" do
      expect(rendered).not_to have_content(t(:leaderboard_position))
    end

    it "should not display recent games" do
      expect(rendered).not_to have_content(t(:recent_games))
    end

    it "should display message" do
      expect(rendered).to have_content(t(:no_games))
    end
  end
end
