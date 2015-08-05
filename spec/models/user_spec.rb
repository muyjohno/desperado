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

  describe "password confirmation" do
    it "works when confirming" do
      user.password = "Newpass"
      user.password_confirmation = "Newpass"

      expect(user).to be_valid
    end

    it "fails non-confirmed passwords" do
      user.password = "Newpass"

      expect(user).not_to be_valid
    end

    it "fails non-matching passwords" do
      user.password = "Newpass"
      user.password_confirmation = "doesn'tmatch"

      expect(user).not_to be_valid
    end

    it "allows non-changed password" do
      expect(User.find(user.id)).to be_valid
    end
  end
end
