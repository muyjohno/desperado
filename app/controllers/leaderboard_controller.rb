class LeaderboardController < ApplicationController
  include MarkdownContent

  def show
    @leaderboard = leaderboard.sorted_rows
    @recent_games = Game.recent
    @content = markdown(league.home_content)
  end
end
