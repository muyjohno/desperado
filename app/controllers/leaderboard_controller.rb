class LeaderboardController < ApplicationController
  def show
    @leaderboard = leaderboard.sorted_rows
  end
end
