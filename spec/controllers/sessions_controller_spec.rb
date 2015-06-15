RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let(:user) { create(:user) }
    before do
      user
    end

    it "sets session user id" do
      post :create, username: "username", password: "password"

      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "GET #destroy" do
    it "unsets session user id" do
      session[:user_id] = 999
      delete :destroy

      expect(session[:user_id]).to eq(nil)
    end
  end
end
