RSpec.describe TiebreakersController, type: :controller do
  context "authorised" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authorise).
        and_return(nil)
    end

    describe "GET index" do
      before do
        create_tiebreaker(:most_points)
        get :index
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end

      it "assigns tiebreakers correctly" do
        expect(assigns(:tiebreakers)).to be_a(ActiveRecord::Relation)
        assigns(:tiebreakers).each do |row|
          expect(row).to be_a(Tiebreaker)
        end
      end
    end

    describe "POST create" do
      it "is successful" do
        expect do
          post :create, tiebreaker: { tiebreaker: :most_points }
        end.to change(Tiebreaker, :count).by(1)

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:added_tiebreaker))
      end

      it "fails correctly" do
        create_tiebreaker(:most_points)

        expect do
          post :create, tiebreaker: { tiebreaker: :most_points }
        end.to change { Tiebreaker.count }.by(0)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
        expect(flash[:alert]).to eq(I18n.t(:add_tiebreaker_failed))
      end
    end

    describe "POST update" do
      let(:tiebreaker1) { create_tiebreaker(:most_points, 1) }
      let(:tiebreaker2) { create_tiebreaker(:fewest_played, 2) }

      it "is successful" do
        post :update,
          id: tiebreaker2.to_param,
          tiebreaker: { ordinal_position: 1 }

        expect(tiebreaker1.reload.ordinal).to be > tiebreaker2.reload.ordinal
        expect(response).to have_http_status(:ok)
      end
    end

    describe "DELETE destroy" do
      let!(:tiebreaker) { create_tiebreaker(:most_points, 1) }

      it "is successful" do
        expect do
          post :destroy, id: tiebreaker.to_param
        end.to change(Tiebreaker, :count).by(-1)

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:removed_tiebreaker))
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
        let(:go) { post :create }
      end
    end

    describe "POST update" do
      it_behaves_like "a restricted controller" do
        let(:go) { post :update, id: 1 }
      end
    end

    describe "DELETE destroy" do
      it_behaves_like "a restricted controller" do
        let(:go) { delete :destroy, id: 1 }
      end
    end
  end
end
