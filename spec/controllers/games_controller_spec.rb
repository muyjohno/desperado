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
        21.times { create(:game, corp: player1, week: 1) }
      end

      it "is successful" do
        get :index

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end

      it "assigns games correctly" do
        get :index

        expect(assigns(:games)).to be_a(ActiveRecord::Relation)
        assigns(:games).each do |row|
          expect(row).to be_a(Game)
        end
      end

      describe "pagination" do
        it "displays correct games on page one" do
          get :index

          expect(assigns(:games)).to include(Game.last)
          expect(assigns(:games)).to include(Game.second)
          expect(assigns(:games)).not_to include(Game.first)
        end

        it "displays correct games on page two" do
          get :index, page: 2

          expect(assigns(:games)).not_to include(Game.last)
          expect(assigns(:games)).not_to include(Game.second)
          expect(assigns(:games)).to include(Game.first)
        end
      end

      describe "filters" do
        it "ignores empty filters" do
          get :index, filter: { corp_id: "", runner_id: "", week: "" }

          expect(assigns(:games).length).to eq(20)
        end

        it "assigns filters" do
          get :index, filter: { corp_id: 1, runner_id: "", week: 2 }

          expect(assigns(:filters)).to eq("corp_id" => "1", "week" => "2")
        end

        describe "filtering by player" do
          let(:other_player) { Game.first.runner }

          it "filters by player1" do
            get :index, filter: { corp_id: player1.to_param }

            expect(assigns(:games).length).to eq(20)
          end

          it "filters by another player" do
            get :index, filter: { runner_id: other_player.to_param }

            expect(assigns(:games).length).to eq(1)
          end

          it "returns empty set" do
            get :index, filter: { corp_id: player2.to_param }

            expect(assigns(:games).length).to eq(0)
          end
        end

        describe "filtering by week" do
          before { create(:game, week: 2) }

          it "filters by week 1" do
            get :index, filter: { week: 1 }

            expect(assigns(:games).length).to eq(20)
          end

          it "filters by week 2" do
            get :index, filter: { week: 2 }

            expect(assigns(:games).length).to eq(1)
          end

          it "returns empty set" do
            get :index, filter: { week: 3 }

            expect(assigns(:games).length).to eq(0)
          end
        end
      end
    end

    describe "GET new" do
      context "with players" do
        before do
          create(:player)
          create(:player)
          get :new
        end

        it "is successful" do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:new)
        end

        it "assigns games correctly" do
          expect(assigns(:game)).to be_a(Game)
        end
      end

      context "without players" do
        before do
          get :new
        end

        it "fails correctly" do
          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:no_players_exist))
        end
      end
    end

    describe "POST create" do
      context "with reverse" do
        it "is successful" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player2.id, result: :corp_win, week: 1 },
              reverse_result: :corp_win
          end.to change(Game, :count).by(2)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:created_game))
        end

        it "fails correctly" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player1.id, result: :corp_win, week: 1 },
              reverse_result: :corp_win
          end.to change(Game, :count).by(0)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:create_game_failed))
        end

        it "creates reverse achievements" do
          achievement = create(:achievement, side: :corp)
          expect do
            post :create,
              game: {
                corp_id: player1.id,
                runner_id: player2.id,
                result: :corp_win
              },
              reverse_result: :corp_win,
              reverse_achievements: {
                achievement.id.to_s => "1"
              }
          end.to change(EarnedAchievement, :count).by(1)

          expect(EarnedAchievement.last.achievement).to eq(achievement)
          expect(EarnedAchievement.last.player).to eq(player2)
        end
      end

      context "without reverse" do
        it "is successful" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player2.id, result: :runner_time_win, week: 3 },
              reverse_result: ""
          end.to change(Game, :count).by(1)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:created_game))
          expect(Game.last.corp).to eq(player1)
          expect(Game.last.runner).to eq(player2)
          expect(Game.last.runner_time_win?).to eq(true)
          expect(Game.last.week).to eq(3)
        end

        it "fails correctly" do
          expect do
            post :create,
              game: { corp_id: player1.id, runner_id: player1.id, result: :corp_win, week: 1 }
          end.to change(Game, :count).by(0)

          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq(I18n.t(:create_game_failed))
        end

        it "creates achievements" do
          achievement = create(:achievement, side: :corp)
          expect do
            post :create,
              game: {
                corp_id: player1.id,
                runner_id: player2.id,
                result: :corp_win
              },
              achievements: {
                achievement.id.to_s => "1"
              }
          end.to change(EarnedAchievement, :count).by(1)

          expect(EarnedAchievement.last.achievement).to eq(achievement)
          expect(EarnedAchievement.last.player).to eq(player1)
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

      it "creates achievements" do
        achievement = create(:achievement, side: :corp)
        expect do
          post :update,
            id: game.id,
            game: { result: game.result },
            achievements: {
              achievement.id.to_s => "1"
            }
        end.to change(EarnedAchievement, :count).by(1)

        expect(EarnedAchievement.last.achievement).to eq(achievement)
        expect(EarnedAchievement.last.player).to eq(game.corp)
        expect(EarnedAchievement.last.game).to eq(game)
      end

      it "delete achievements" do
        achievement = create(:achievement, side: :corp)
        game.add_achievement(achievement)
        expect do
          post :update,
            id: game.id,
            game: { result: game.result },
            achievements: {
              achievement.id.to_s => "0"
            }
        end.to change(EarnedAchievement, :count).by(-1)
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

    describe "GET new" do
      it_behaves_like "a restricted controller" do
        let(:go) { get :new }
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
