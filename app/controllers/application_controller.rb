class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def ruleset
    @ruleset ||= Ruleset.new
  end
end
