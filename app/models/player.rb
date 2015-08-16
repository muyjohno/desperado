class Player < ActiveRecord::Base
  validates :name, presence: true

  has_many :corp_games,
    class_name:   "Game",
    foreign_key:  :corp_id,
    dependent:    :destroy
  has_many :runner_games,
    class_name:   "Game",
    foreign_key:  :runner_id,
    dependent:    :destroy

  has_many :earned_achievements, dependent: :destroy
  has_many :achievements, through: :earned_achievements

  def games
    Game.where("corp_id = ? OR runner_id = ?", id, id)
  end

  def earned?(ach)
    achievements.include?(ach)
  end
end
