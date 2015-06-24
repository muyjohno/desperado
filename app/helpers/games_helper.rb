module GamesHelper
  def result_options
    Game.results.keys.map { |result| [t(result).titleize, result] }
  end
end
