module Points
  class Participation
    def calculate(game, row)
      @game = game
      @row = row

      points = [points_for_participation, total_remaining, week_remaining].min
      [points, 0].max
    end

    def total_remaining
      Rule.value_for("max_points_for_participation", 100) - current
    end

    def week_remaining
      Rule.value_for("max_points_for_participation_per_week", 100) - weekly
    end

    def points_for_participation
      @points_for_participation = Rule.value_for("points_for_participation", 0)
    end

    private

    def current
      @current = @row.participation_points
    end

    def weekly
      @weekly = (games_for_week.length-1) * points_for_participation
    end

    def games_for_week
      @row.games_for_week(@game.week)
    end
  end
end
