RSpec.describe LeagueController, type: :controller do
  context "authorised" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authorise)
        .and_return(nil)
    end

    describe "GET edit" do
      before do
        get :edit
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end

      it "assigns game" do
        expect(assigns(:league)).to eq(League.current)
      end
    end

    describe "POST update" do
      it "is successful" do
        post :update, league: { name: "Test" }

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:updated_league))
      end

      it "updates achievement" do
        expect_any_instance_of(League).to receive(:update_attributes)
          .with("name" => "Test")

        post :update, league: { name: "Test" }
      end
    end
  end

  context "not authorised" do
    describe "GET edit" do
      it_behaves_like "a restricted controller" do
        let(:go) { get :edit }
      end
    end

    describe "POST update" do
      it_behaves_like "a restricted controller" do
        let(:go) { post :update, league: { name: "Test" } }
      end
    end
  end
end
