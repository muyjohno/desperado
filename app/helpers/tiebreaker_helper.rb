module TiebreakerHelper
  def tiebreaker_options
    Tiebreaker.available_tiebreakers.keys.map { |tb| [t(tb), tb] }
  end
end
