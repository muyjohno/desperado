RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it "authenticates" do
    expect(user.authenticate?("password")).to eq(true)
    expect(user.authenticate?("wrong password")).to eq(false)
  end

  it "fetches user from credentials" do
    user

    expect(User.authenticate("username", "password")).to eq(user)
  end

  it "doesn't expose password" do
    copy = User.find(user.id)

    expect(copy.password).to eq(nil)
  end
end
