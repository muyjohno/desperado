User.create!(username: "admin", password: "admin", password_confirmation: "admin")

Rule.create!(key: :points_for_win, value: 2, ordinal: 0)
Rule.create!(key: :points_for_time_win, value: 1, ordinal: 1)
Rule.create!(key: :points_for_tie, value: 1, ordinal: 2)
Rule.create!(key: :points_for_loss, value: 0, ordinal: 3)

Tiebreaker.create!(tiebreaker: :most_points, ordinal: 0)
