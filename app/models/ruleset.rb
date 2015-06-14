class Ruleset
  def compare(a, b)
    rankers.each do |ranker|
      decision = ranker.compare(a, b)
      return decision if decision != 0
    end
    0
  end

  private

  def rankers
    [Ranker::MostPoints, Ranker::MostWeakSideWins, Ranker::FewestPlayed]
  end
end
