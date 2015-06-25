shared_examples "a restricted controller" do
  it "is unsuccessful" do
    go

    expect(response).to have_http_status(:redirect)
    expect(flash[:notice]).to eq(I18n.t(:not_authorised))
  end
end
