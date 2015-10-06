module Points
  class Participation
    def calculate(game, row)
      @game = game
      @row = row

      points_for_participation.tap do |points|
        return 0 if current >= max || week_current >= week_max
        return (max - current) if (current + points) >= max
        return (week_max - week_current) if (week_current + points) >= week_max
      end
    end

    def max
      @max = Rule.value_for("max_points_for_participation", 100)
    end

    def week_max
      @week_max = Rule.value_for("max_points_for_participation_per_week", 100)
    end

    def points_for_participation
      @points_for_participation = Rule.value_for("points_for_participation", 0)
    end

    private

    def current
      @current = @row.participation_points
    end

    def week_current
      @week_current = games_for_week.length * points_for_participation
    end

    def games_for_week
      @row.games_for_week(@game.week)
    end
  end
end
