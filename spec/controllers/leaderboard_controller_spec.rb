RSpec.describe LeaderboardController, type: :controller do
  describe "GET show" do
    before do
      create(:game)
      create(:game)
      get :show
    end

    it "is successful" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end

    it "assigns leaderboard correctly" do
      expect(assigns(:leaderboard)).to be_a(Array)
      assigns(:leaderboard).each do |row|
        expect(row).to be_a(LeaderboardRow)
      end
    end

    it "assigns recent_games correctly" do
      expect(assigns(:recent_games)).to be_a(ActiveRecord::Relation)
      expect(assigns(:recent_games).count).to eq(2)
    end
  end
end
