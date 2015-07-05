module AchievementHelper
  def create_earned_achievement
    game = create(:game)
    achievement = create(:achievement, side: :corp)
    create(
      :earned_achievement,
      game: game, player: game.corp, achievement: achievement
    )
  end
end
