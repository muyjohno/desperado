module TiebreakerHelper
  def create_tiebreaker(tiebreaker, ordinal = 0)
    create(:tiebreaker, tiebreaker: tiebreaker, ordinal: ordinal)
  end
end
