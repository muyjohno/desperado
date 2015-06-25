RSpec.describe GamesController, type: :controller do
  context "authorised" do
    let(:game) { create(:game) }
    let(:player1) { create(:player) }
    let(:player2) { create(:player) }

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

      it "assigns games correctly" do
        expect(assigns(:games)).to be_a(ActiveRecord::Relation)
        assigns(:games).each do |row|
          expect(row).to be_a(Game)
        end
      end
    end

    describe "POST create" do
      context "with reverse" do
        it "is successful" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player2.id, result: :corp_win },
              reverse_result: :corp_win
          end.to change{ Game.count }.by(2)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:created_game))
        end

        it "fails correctly" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player1.id, result: :corp_win },
              reverse_result: :corp_win
          end.to change{ Game.count }.by(0)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:create_game_failed))
        end
      end

      context "without reverse" do
        it "is successful" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player2.id, result: :corp_win }
          end.to change{ Game.count }.by(1)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:created_game))
        end

        it "fails correctly" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player1.id, result: :corp_win }
          end.to change{ Game.count }.by(0)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:create_game_failed))
        end
      end
    end

    describe "GET edit" do
      before do
        get :edit, id: game.id
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end

      it "assigns game" do
        expect(assigns(:game)).to eq(game)
      end
    end

    describe "POST update" do
      it "is successful" do
        post :update, id: game.id, game: { result: :runner_win }

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:updated_game))
      end

      it "updates game" do
        expect_any_instance_of(Game).to receive(:update_attributes)
          .with("result" => "runner_win")

        post :update, id: game.id, game: { result: :runner_win }
      end

      it "fails correctly" do
        post :update, id: game.id, game: { corp_id: game.runner_id }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to eq(I18n.t(:update_game_failed))
      end
    end

    describe "DELETE destroy" do
      let(:game_to_delete) { create(:game) }

      it "is successful" do
        delete :destroy, id: game_to_delete.id

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:deleted_game))
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
        let(:go) do
          post :create,
            game: { corp_id: 1, runner_id: 2, result: :corp_win }
        end
      end
    end

    describe "GET edit" do
      it_behaves_like "a restricted controller" do
        let(:go) { get :edit, id: 1 }
      end
    end

    describe "POST update" do
      it_behaves_like "a restricted controller" do
        let(:go) { post :update, id: 1, game: { result: :runner_win } }
      end
    end

    describe "DELETE destroy" do
      it_behaves_like "a restricted controller" do
        let(:go) { delete :destroy, id: 1 }
      end
    end
  end
end
