class Player < ActiveRecord::Base
  validates :name, presence: true

  has_many :corp_games, class_name: "Game", foreign_key: :corp_id
  has_many :runner_games, class_name: "Game", foreign_key: :runner_id

  def games
    Game.where("corp_id = ? OR runner_id = ?", id, id)
  end
end
