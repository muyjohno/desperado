class LeaderboardRow
  include Comparable

  attr_accessor :position
  attr_reader :player, :points, :played, :corp_wins, :runner_wins
  attr_reader :participation_points, :achievement_points

  delegate :points_for_result, to: :@ruleset
  delegate :points_for_participation, to: :@ruleset

  def initialize(player, ruleset)
    @position = 0
    @player = player
    @points = 0
    @played = 0
    @corp_wins = 0
    @runner_wins = 0
    @participation_points = 0
    @achievement_points = 0

    @ruleset = ruleset
  end

  def add_game(game)
    @played += 1
    @corp_wins += 1 if corp?(game) && result(game) == :win
    @runner_wins += 1 if runner?(game) && result(game) == :win
    @points += points_for_result(result(game))
    game.points_for_achievements(@player).tap do |ap|
      @points += ap
      @achievement_points += ap
    end
    points_for_participation(@participation_points).tap do |pp|
      @points += pp
      @participation_points += pp
    end
  end

  def <=>(other)
    @ruleset.compare(self, other)
  end

  def weak_side_wins
    @corp_wins > @runner_wins ? @runner_wins : @corp_wins
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
end
