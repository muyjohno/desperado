RSpec.describe League, type: :model do
  describe ".current" do
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

  describe "#display_name" do
    let(:league) { League.current }

    it "returns league name" do
      league.name = "Custom name"

      expect(league.display_name).to eq("Custom name")
    end

    it "defaults" do
      league.name = ""

      expect(league.display_name).to eq("Desperado")
    end
  end

  describe "#all_rules" do
    let(:league) { League.current }

    it "returns stubbed rules" do
      expect(league.all_rules.length).to eq(Rule::KEYS.length)
      expect(league.all_rules.first.key).to eq("points_for_win")
    end
  end

  describe "validation" do
    let(:league) { League.current }

    describe "theme" do
      it "should allow valid theme" do
        league.theme = :default

        expect(league).to be_valid
      end

      it "should allow no theme" do
        league.theme = nil

        expect(league).to be_valid
      end

      it "should not allow invalid theme" do
        expect do
          league.theme = :theme_that_doesnt_exist
        end.to raise_error(ArgumentError)
      end
    end
  end
end
