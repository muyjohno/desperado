class Ruleset
  def compare(a, b)
    rankers.each do |ranker|
      decision = ranker.compare(a, b)
      return decision if decision != 0
    end
    0
  end

  def rankers
    Tiebreaker.ordered.map do |t|
      "Ranker::#{t.tiebreaker.camelize}".constantize
    end
  end

  def apply_stats(row, all_rows)
    rankers.each { |ranker| ranker.apply_stats(row, all_rows, self) }
  end

  def points_for(what, game, row)
    "Points::#{what.to_s.titleize}".constantize.new.calculate(game, row)
  end
end
