class EarnedAchievement < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  belongs_to :achievement

  validates :player, :game, :achievement, presence: true
  validate :integrity?

  private

  def integrity?
    return unless game && achievement && player
    errors.add(:player, "couldn't earn achievement for game") unless
      player == game.send(achievement.side)
  end
end
