RSpec.describe LeaderboardController, type: :controller do
  describe "GET show" do
    before do
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
  end
end
