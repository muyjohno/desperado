RSpec.describe PlayersController, type: :controller do
  let(:player) { create(:player) }

  describe "GET index" do
    before do
      get :index
    end

    it "is successful" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end

    it "assigns players correctly" do
      expect(assigns(:players)).to be_a(ActiveRecord::Relation)
      assigns(:players).each do |row|
        expect(row).to be_a(Player)
      end
    end
  end

  describe "POST create" do
    before do
      post :create, player: { name: "Test" }
    end

    it "is successful" do
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq(I18n.t(:created_player))
    end
  end

  describe "GET edit" do
    before do
      get :edit, id: player.id
    end

    it "is successful" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
    end

    it "assigns player" do
      expect(assigns(:player)).to eq(player)
    end
  end

  describe "POST update" do
    it "is successful" do
      post :update, id: player.id, player: { name: "New name" }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq(I18n.t(:updated_player))
    end

    it "updates player" do
      expect_any_instance_of(Player).to receive(:update_attributes)
        .with("name" => "New name")

      post :update, id: player.id, player: { name: "New name" }
    end

    it "fails correctly" do
      post :update, id: player.id, player: { name: "" }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(flash[:alert]).to eq(I18n.t(:update_player_failed))
    end
  end

  describe "DELETE destroy" do
    let(:player_to_delete) { create(:player) }

    it "is successful" do
      delete :destroy, id: player_to_delete.id

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq(I18n.t(:deleted_player))
    end
  end
end
