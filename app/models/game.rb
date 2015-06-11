class Game < ActiveRecord::Base
  validates :corp, :runner, :result, presence: true
  validate :cannot_play_self

  belongs_to :corp, class_name: "Player"
  belongs_to :runner, class_name: "Player"

  private

  def cannot_play_self
    errors.add(:runner, "cannot play self") unless corp_id != runner_id
  end
end
