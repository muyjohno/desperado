class TiebreakersController < ApplicationController
  before_action :authorise

  def index
    @tiebreakers = Tiebreaker.ordered
  end

  def create
    if Tiebreaker.new(create_params).save
      redirect_to tiebreakers_path, notice: t(:added_tiebreaker)
    else
      flash.now.alert = t(:add_tiebreaker_failed)
      @tiebreakers = Tiebreaker.ordered
      render :index
    end
  end

  def update
    @tiebreaker = Tiebreaker.find(params[:id])
    @tiebreaker.ordinal_position = update_params[:ordinal_position]
    @tiebreaker.save

    render nothing: true
  end

  def destroy
    @tiebreaker = Tiebreaker.find(params[:id])
    @tiebreaker.destroy

    redirect_to tiebreakers_path, notice: t(:removed_tiebreaker)
  end

  private

  def create_params
    params.require(:tiebreaker).permit(:tiebreaker)
  end

  def update_params
    params.require(:tiebreaker).permit(:ordinal_position)
  end
end
