class Ruleset
  def compare(a, b)
    rankers.each do |ranker|
      decision = ranker.compare(a, b)
      return decision if decision != 0
    end
    0
  end

  def points_for_result(result)
    Rule.value_for("points_for_#{result}", 0)
  end

  def points_for_participation(current)
    max = Rule.value_for("max_points_for_participation", 100)
    Rule.value_for("points_for_participation", 0).tap do |points|
      return 0 if current >= max
      return (max - current) if (current + points) >= max
    end
  end

  def rankers
    Tiebreaker.ordered.map { |t| "Ranker::#{t.tiebreaker.camelize}".constantize }
  end
end
