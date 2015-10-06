module Points
  class Result
    def calculate(game, row)
      result = game.player_result(row.player)
      Rule.value_for("points_for_#{result}", 0)
    end
  end
end
