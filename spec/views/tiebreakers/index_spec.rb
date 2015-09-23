RSpec.describe "tiebreakers/index.html.haml", type: :view do
  before do
    tiebreakers = [].tap do |collection|
      collection << create(:tiebreaker, tiebreaker: :most_points)
      collection << create(:tiebreaker, tiebreaker: :highest_strength_of_schedule)
      collection << create(:tiebreaker, tiebreaker: :fewest_played)
    end

    assign(:tiebreakers, tiebreakers)

    render
  end

  it "should display tiebreaker list" do
    expect(rendered).to have_content(t(:edit_tiebreakers))
    expect(rendered).to have_css("tr", count: 3)
    expect(rendered).to have_content(t(:add_tiebreaker))
  end
end
