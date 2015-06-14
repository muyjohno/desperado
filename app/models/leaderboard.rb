class Leaderboard
  attr_reader :rows

  def initialize(games, ruleset)
    @ruleset = ruleset
    @rows = {}
    games.each do |game|
      process_game(game)
    end
  end

  def sorted_rows
    rows.map { |_, row| row }.sort.tap do |sorted|
      sorted.each_with_index do |row, index|
        row.position = index + 1
      end
    end
  end

  private

  def process_game(game)
    row(game.corp).add_game(game)
    row(game.runner).add_game(game)
  end

  def row(player)
    @rows[player.id] ||= LeaderboardRow.new(player, @ruleset)
  end
end
