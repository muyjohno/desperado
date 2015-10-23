RSpec.describe "games/index.html.haml", type: :view do
  let(:geoff) { create(:player, name: "Geoff") }
  let(:games) { Game.by_week.page(1).per(20) }

  before do
    3.times { create(:game, corp: geoff) }
    assign(:games, games)
    assign(:filters, {})
  end

  it "should display game list" do
    render

    expect(rendered).to have_content(t(:games))
    expect(rendered).to have_css("tr", count: 5)
    expect(rendered).to have_content(t(:corp_win), count: 3)
  end

  context "with bye" do
    before do
      create(:game, corp: geoff, runner_id: nil, result: :bye)

      assign(:games, games)
    end

    it "should display bye message" do
      render

      expect(rendered).to have_content(t(:bye))
    end
  end

  context "many games" do
    before do
      18.times { create(:game) }
      assign(:games, games)
    end

    it "should display page links" do
      render

      expect(rendered).to have_content(t("views.pagination.next"))
      expect(rendered).to have_css("nav ul.pagination li a[rel=next]")
    end
  end

  describe "filters" do
    before do
      assign(:filters, { corp_id: geoff.id, week: 2 })
    end

    it "should display filter fields" do
      render

      expect(rendered).to have_css("input[name=\"filter[week]\"]")
      expect(rendered).to have_css("select[name=\"filter[corp_id]\"]")
      expect(rendered).to have_css("select[name=\"filter[runner_id]\"]")
    end

    it "should populate fields" do
      render

      expect(rendered).to match(/option selected=\"selected\" value=\"#{geoff.id}\"/)
      expect(rendered).to have_css("input#filter_week[value=\"2\"]")
    end
  end
end
