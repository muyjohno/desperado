module AchievementsHelper
  def side_options
    Achievement.sides.keys.map { |side| [t(side).titleize, side] }
  end
end
