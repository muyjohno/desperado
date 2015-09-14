module GameHelper
  def create_game(corp, runner, result)
    create(:game, corp: corp, runner: runner, result: result)
  end
end
