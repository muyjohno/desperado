class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorise
    redirect_to root_path, notice: t(:not_authorised) unless current_user
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def leaderboard
    Leaderboard.new(games, ruleset)
  end

  private

  def ruleset
    @ruleset ||= Ruleset.new
  end

  def games
    Game.all
  end
end
