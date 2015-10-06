module Points
  class Achievement
    def calculate(game, row)
      game.points_for_achievements(row.player)
    end
  end
end
