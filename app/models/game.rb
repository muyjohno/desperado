class Game < ActiveRecord::Base
  validates :corp, :runner, :result, presence: true, unless: "bye?"
  validate :exactly_one_player_for_bye
  validate :cannot_play_self

  belongs_to :corp, class_name: "Player"
  belongs_to :runner, class_name: "Player"

  has_many :earned_achievements, dependent: :destroy
  has_many :achievements, through: :earned_achievements

  enum result: %w(corp_win runner_win corp_time_win runner_time_win tie bye)

  scope :recent, -> { order(week: :desc, created_at: :desc).limit(10) }

  def player_result(player)
    return :bye if bye? && side(player)
    return :win if player_win?(player)
    return :time_win if player_time_win?(player)
    return :tie if tie?
    return :loss if side(player)
  end

  def player_win?(player)
    (player == corp && corp_win?) || (player == runner && runner_win?)
  end

  def player_time_win?(player)
    (player == corp && corp_time_win?) || (player == runner && runner_time_win?)
  end

  def player_achievements(player)
    earned_achievements.where(player: player).collect(&:achievement)
  end

  def side(player)
    return :corp if player == corp
    return :runner if player == runner
  end

  def opponent(player)
    return runner if side(player) == :corp
    return corp if side(player) == :runner

    Null::Player.new
  end

  def winner
    return runner if runner_win? || runner_time_win?
    return corp if corp_win? || corp_time_win?

    Null::Player.new
  end

  def bye_player
    return runner if runner_id
    return corp if corp_id

    Null::Player.new
  end

  def corp_player
    corp || Null::Player.new
  end

  def runner_player
    runner || Null::Player.new
  end

  def add_achievement(achievement)
    earned_achievements << EarnedAchievement.new(
      achievement: achievement,
      player: send(achievement.side)
    )
  end

  def remove_achievement(achievement)
    earned_achievements.where(achievement: achievement).destroy_all
  end

  def achievement?(achievement)
    earned_achievements.where(achievement: achievement).count > 0
  end

  def points_for_achievements(player)
    earned_achievements.where(player: player).inject(0) do |sum, ea|
      sum + ea.achievement.points
    end
  end

  private

  def cannot_play_self
    errors.add(:runner, "cannot play self") unless corp_id != runner_id
  end

  def exactly_one_player_for_bye
    return unless bye?

    errors.add(:result, "cannot be bye with two players") if corp && runner
    errors.add(:result, "cannot be bye with no players") unless corp || runner
  end
end
