class Leaderboard
  def initialize(games, ruleset)
    @ruleset = ruleset
    @rows_by_player = {}
    games.each do |game|
      process_game(game)
    end
  end

  def sorted_rows
    rows.sort.tap do |sorted|
      sorted.each_with_index do |row, index|
        row.position = index + 1
      end
    end
  end

  def row_for(player)
    sorted_rows.each do |row|
      return row if row.player == player
    end
    nil
  end

  def rows
    @rows_by_player.map do |_, row|
      @ruleset.apply_stats(row)
    end
  end

  private

  def process_game(game)
    row(game.corp).add_game(game)
    row(game.runner).add_game(game)
  end

  def row(player)
    @rows_by_player[player.id] ||= LeaderboardRow.new(player, @ruleset)
  end
end
