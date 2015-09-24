RSpec.describe "players/show.html.haml", type: :view do
  create_sample_league

  before do
    3.times { create(:achievement, title: "Be Amazing") }
    assign(:player, adam)
    assign(:leaderboard_row, adam_row)
    assign(:achievements, Achievement.all)
    assign(:games, adam.games.group_by { |g| g.week.to_i })
  end

  it "should display player stats" do
    render

    expect(rendered).to have_content("Adam")
    expect(rendered).to have_content("1/1")
  end

  it "should display player games" do
    render

    expect(rendered).to have_content("Week 1")
    expect(rendered).to have_content("Played Corp against Ben: Win")
  end

  it "should display achievements" do
    render

    expect(rendered).to have_css(".achievement", count: 3)
    expect(rendered).to have_content("Be Amazing", count: 3)
  end

  context "with a bye" do
    before do
      create(:game, corp: adam, runner_id: nil, result: :bye)
      assign(:games, adam.games.group_by { |g| g.week.to_i })
    end

    it "should display bye message" do
      render

      expect(rendered).to have_content("Adam had a bye")
    end
  end
end
