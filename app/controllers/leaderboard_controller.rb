class LeaderboardController < ApplicationController
  def show
    @leaderboard = leaderboard.sorted_rows
    @recent_games = Game.recent
  end
end
