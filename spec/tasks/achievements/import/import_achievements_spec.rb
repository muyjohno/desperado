describe "desperado:import_achievements" do
  include_context "desperado"

  before(:each) do
    Achievement.delete_all
  end

  it "imports two valid achievements." do
    subject.invoke data_file("two_valid_achievements.yml")
    expect(Achievement.count).to eq 2

    expect(Achievement.find_by_title("First")).to be_present
    expect(Achievement.find_by_title("Second")).to be_present
  end

  it "does not import any achievements when even one input is invalid." do
    expect do
      subject.invoke data_file("with_one_invalid_achievement.yml")
    end.to raise_error(NameError)

    expect(Achievement.count).to eq 0
  end

  def data_file(path)
    File.join("#{File.dirname(__FILE__)}", path)
  end
end
