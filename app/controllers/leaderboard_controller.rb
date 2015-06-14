class LeaderboardController < ApplicationController
  def show
    @leaderboard = Leaderboard.new(games, ruleset).sorted_rows
  end

  private

  def games
    Game.all
  end
end
