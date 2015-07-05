module GamesHelper
  def result_options
    Game.results.keys.map { |result| [t(result).titleize, result] }
  end

  def corp_achievements
    Achievement.corp
  end

  def runner_achievements
    Achievement.runner
  end
end
