class Ruleset
  def compare(a, b)
    rankers.each do |ranker|
      decision = ranker.compare(a, b)
      return decision if decision != 0
    end
    0
  end

  def points_for_result(result)
    Rules::PointFactory.points_for_result(result)
  end

  private

  def rankers
    [Ranker::MostPoints, Ranker::MostWeakSideWins, Ranker::FewestPlayed]
  end
end
