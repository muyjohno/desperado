class LeagueController < ApplicationController
  before_action :authorise

  def edit
  end

  def update
    if @league.update_attributes(league_params)
      redirect_to edit_league_path, notice: t(:updated_league)
    else
      flash.now.alert = t(:update_league_failed)
      render :edit
    end
  end

  private

  def league_params
    params.require(:league).permit(:name)
  end
end
