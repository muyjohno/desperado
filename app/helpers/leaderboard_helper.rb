module LeaderboardHelper
  def participation_points_active?
    Rule.value_for("points_for_participation", 0) > 0
  end

  def achievement_points_active?
    Achievement.count > 0
  end

  def strength_of_schedule_active?
    Tiebreaker.highest_strength_of_schedule.exists?
  end
end
