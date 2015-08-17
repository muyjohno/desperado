class PlayersController < ApplicationController
  before_action :authorise, except: :show

  def show
    @player = find_player
    @leaderboard_row = leaderboard.row_for(@player)
    @achievements = Achievement.all
    @games = @player.games.group_by{ |g| g.week.to_i }
  end

  def index
    @players = Player.all
  end

  def create
    player = Player.new(player_params)

    redirect_to players_path,
      notice: player.save ? t(:created_player) : t(:create_player_failed)
  end

  def edit
    @player = find_player
  end

  def update
    @player = find_player
    if @player.update_attributes(player_params)
      redirect_to players_path, notice: t(:updated_player)
    else
      flash.now.alert = t(:update_player_failed)
      render :edit
    end
  end

  def destroy
    @player = find_player
    redirect_to players_path,
      notice: @player.destroy ? t(:deleted_player) : t(:delete_player_failed)
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end

  def find_player
    Player.find(params[:id])
  end
end
