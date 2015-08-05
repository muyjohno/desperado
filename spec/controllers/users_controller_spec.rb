RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  context "authorised" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authorise)
        .and_return(nil)
      allow_any_instance_of(ApplicationController).to receive(:current_user)
        .and_return(user)
    end

    describe "GET edit" do
      before do
        get :edit
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end

      it "assigns user" do
        expect(assigns(:user)).to eq(user)
      end
    end

    describe "POST update" do
      it "is successful" do
        post :update, user: { password: "Newpass", password_confirmation: "Newpass" }

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t(:updated_password))
      end

      it "updates user" do
        expect_any_instance_of(User).to receive(:update_attributes)
          .with("password" => "Newpass", "password_confirmation" => "Newpass")

        post :update, user: { password: "Newpass", password_confirmation: "Newpass" }
      end

      it "fails correctly" do
        post :update, user: { password: "" }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to eq(I18n.t(:update_password_failed))
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
        let(:go) { post :update, user: { password: "Newpass" } }
      end
    end
  end
end
