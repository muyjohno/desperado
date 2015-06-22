class PlayersController < ApplicationController
  before_action :find_player, only: [:edit, :update, :destroy]

  def index
    @players = Player.all
  end

  def create
    player = Player.new(player_params)

    redirect_to players_path,
      notice: player.save ? t(:created_player) : t(:create_player_failed)
  end

  def edit
  end

  def update
    if @player.update_attributes(player_params)
      redirect_to players_path, notice: t(:updated_player)
    else
      flash.now.alert = t(:update_player_failed)
      render :edit
    end
  end

  def destroy
    redirect_to players_path,
      notice: @player.destroy ? t(:deleted_player) : t(:delete_player_failed)
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end

  def find_player
    @player = Player.find(params[:id])
  end
end
