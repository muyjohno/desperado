class Game < ActiveRecord::Base
  validates :corp, :runner, :result, presence: true
  validate :cannot_play_self

  belongs_to :corp, class_name: "Player"
  belongs_to :runner, class_name: "Player"

  has_many :earned_achievements, dependent: :destroy
  has_many :achievements, through: :earned_achievements

  enum result: %w(corp_win runner_win corp_time_win runner_time_win tie)

  def player_result(player)
    return :win if player_win?(player)
    return :time_win if player_time_win?(player)
    return :tie if tie?
    :loss
  end

  def player_win?(player)
    (player == corp && corp_win?) || (player == runner && runner_win?)
  end

  def player_time_win?(player)
    (player == corp && corp_time_win?) || (player == runner && runner_time_win?)
  end

  def side(player)
    player == corp ? :corp : :runner
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
end
