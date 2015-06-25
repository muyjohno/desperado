RSpec.describe PlayersController, type: :controller do
  let(:player) { create(:player) }

  describe "unrestricted actions" do
    describe "GET show" do
      context "player with games" do
        before do
          create(:game, corp: player, runner: create(:player), result: :corp_win)
          get :show, id: player.id
        end

        it "is successful" do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:show)
        end

        it "assigns player correctly" do
          expect(assigns(:player)).to eq(player)
        end

        it "assigns leaderboard row correctly" do
          expect(assigns(:leaderboard_row)).to be_a(LeaderboardRow)
          expect(assigns(:leaderboard_row).player).to eq(player)
        end
      end

      context "player without games" do
        let(:gameless_player) { create(:player) }

        it "is successful" do
          get :show, id: gameless_player.id

          expect(response).to have_http_status(:ok)
          expect(assigns(:leaderboard_row)).to eq(nil)
        end
      end
    end
  end

  context "authorised" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authorise)
        .and_return(nil)
    end

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

  context "not authorised" do
    describe "GET index" do
      it_behaves_like "a restricted controller" do
        let(:go) { get :index }
      end
    end

    describe "POST create" do
      it_behaves_like "a restricted controller" do
        let(:go) { post :create, player: { name: "Test" } }
      end
    end

    describe "GET edit" do
      it_behaves_like "a restricted controller" do
        let(:go) { get :edit, id: 1 }
      end
    end

    describe "POST update" do
      it_behaves_like "a restricted controller" do
        let(:go) { post :update, id: 1, player: { name: "New name" } }
      end
    end

    describe "DELETE destroy" do
      it_behaves_like "a restricted controller" do
        let(:go) { delete :destroy, id: 1 }
      end
    end
  end
end
