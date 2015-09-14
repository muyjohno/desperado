class LeaderboardRow
  include Comparable

  attr_accessor :position
  attr_reader :player, :points, :played, :corp_wins, :runner_wins
  attr_reader :result_points, :participation_points, :achievement_points

  delegate :points_for_result, to: :@ruleset
  delegate :points_for_participation, to: :@ruleset

  def initialize(player, ruleset)
    @position = 0
    @player = player
    @points = 0
    @played = 0
    @corp_wins = 0
    @runner_wins = 0
    @result_points = 0
    @participation_points = 0
    @achievement_points = 0
    @extra = {}

    @ruleset = ruleset
  end

  def add_game(game)
    @played += 1
    @corp_wins += 1 if corp?(game) && result(game) == :win
    @runner_wins += 1 if runner?(game) && result(game) == :win
    points_for_result(result(game)).tap do |rp|
      @points += rp
      @result_points += rp
    end
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

  def add_stat(key, value)
    @extra[key] = value
  end

  def method_missing(name)
    return @extra[name] if @extra.has_key?(name)
    super
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
