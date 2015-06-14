class LeaderboardRow
  include Comparable

  attr_accessor :position
  attr_reader :player, :points, :played, :corp_wins, :runner_wins

  def initialize(player)
    @position = 0
    @player = player
    @points = 0
    @played = 0
    @corp_wins = 0
    @runner_wins = 0
  end

  def add_game(game)
    @played += 1
    @corp_wins += 1 if corp?(game) && result(game) == :win
    @runner_wins += 1 if runner?(game) && result(game) == :win
    @points += points_for_result(result(game))
  end

  def <=>(other)
    points <=> other.points if points != other.points
    0
  end

  private

  def runner?(game)
    game.side(@player) == :runner
  end

  def corp?(game)
    game.side(@player) == :corp
  end

  def result(game)
    game.player_result(@player)
  end

  def points_for_result(result)
    return 2 if result == :win
    return 1 if result == :time_win || result == :tie
    0
  end
end
