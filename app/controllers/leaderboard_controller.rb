class LeaderboardController < ApplicationController
  def show
    @leaderboard = Leaderboard.new(Game.all).sorted_rows
  end
end
