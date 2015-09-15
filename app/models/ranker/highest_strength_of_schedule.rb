module Ranker
  class HighestStrengthOfSchedule < Base
    def self.apply_stats(row, all_rows, _)
      sos = 0
      row.player.games.each do |game|
        opponent = game.opponent(row.player)
        sos += all_rows[opponent.id].result_points
      end
      row.sos = sos
    end

    def self.compare(a, b)
      -(a.sos <=> b.sos)
    end
  end
end
