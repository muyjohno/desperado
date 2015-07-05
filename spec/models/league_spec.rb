RSpec.describe League, type: :model do
  context "no league exists" do
    it "creates instance" do
      league = League.current
      expect(league).to be_a(League)
      expect(league.id).to eq(League::INSTANCE_ID)
    end
  end

  context "league does exist" do
    before do
      create(:league, id: League::INSTANCE_ID, name: "Existing league")
    end

    it "fetches instance" do
      league = League.current

      expect(league.id).to eq(League::INSTANCE_ID)
      expect(league.name).to eq("Existing league")
    end
  end
end
