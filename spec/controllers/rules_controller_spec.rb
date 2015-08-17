RSpec.describe RulesController, type: :controller do
  describe "GET show" do
    before do
      league = League.current
      league.rules_content = "This is a **test**"
      league.save
      get :show
    end

    it "is successful" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end

    it "assigns content correctly" do
      expect(assigns(:content)).to match("<p>This is a <strong>test</strong></p>")
    end
  end
end
