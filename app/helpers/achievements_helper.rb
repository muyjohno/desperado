module AchievementsHelper
  def side_options
    Achievement.sides.keys.map { |side| [t(side).titleize, side] }
  end

  def achievement_class(ach, player)
    return "panel-info" unless player

    "panel-success" if player.earned?(ach)
  end
end
