RSpec.describe AchievementsController, type: :controller do
  describe "GET index" do
    before do
      create(:achievement)
      get :index
    end

    it "is successful" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end

    it "assigns achievements correctly" do
      expect(assigns(:achievements)).to be_a(ActiveRecord::Relation)
      assigns(:achievements).each do |row|
        expect(row).to be_a(Achievement)
      end
    end
  end

  context "authorised" do
    let(:achievement) { create(:achievement) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:authorise)
        .and_return(nil)
    end

    describe "GET manage" do
      before do
        get :manage
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:manage)
      end

      it "assigns achievements correctly" do
        expect(assigns(:achievements)).to be_a(ActiveRecord::Relation)
        assigns(:achievements).each do |row|
          expect(row).to be_a(Achievement)
        end
      end
    end

    describe "GET new" do
      before do
        get :new
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end

      it "assigns achievement correctly" do
        expect(assigns(:achievement)).to be_a(Achievement)
      end
    end

    describe "POST create" do
      it "is successful" do
        expect do
          post :create,
            achievement: { title: "Test", description: "Desc", points: 1, side: :corp }
        end.to change{ Achievement.count }.by(1)

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:created_achievement))
      end

      it "fails correctly" do
        expect do
          post :create,
            achievement: { title: nil }
        end.to change{ Achievement.count }.by(0)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq(I18n.t(:create_achievement_failed))
      end
    end

    describe "GET edit" do
      before do
        get :edit, id: achievement.id
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end

      it "assigns game" do
        expect(assigns(:achievement)).to eq(achievement)
      end
    end

    describe "POST update" do
      it "is successful" do
        post :update, id: achievement.id, achievement: { side: :runner }

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:updated_achievement))
      end

      it "updates achievement" do
        expect_any_instance_of(Achievement).to receive(:update_attributes)
          .with("side" => "corp")

        post :update, id: achievement.id, achievement: { side: :corp }
      end

      it "fails correctly" do
        post :update, id: achievement.id, achievement: { title: "" }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to eq(I18n.t(:update_achievement_failed))
      end
    end

    describe "DELETE destroy" do
      let(:achievement_to_delete) { create(:achievement) }

      it "is successful" do
        delete :destroy, id: achievement_to_delete.id

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:deleted_achievement))
      end
    end
  end

  context "not authorised" do
    describe "GET manage" do
      it_behaves_like "a restricted controller" do
        let(:go) { get :manage }
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
            achievement: { title: "Test", side: :corp, points: 1 }
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
        let(:go) { post :update, id: 1, achievement: { title: "Test" } }
      end
    end

    describe "DELETE destroy" do
      it_behaves_like "a restricted controller" do
        let(:go) { delete :destroy, id: 1 }
      end
    end
  end
end
