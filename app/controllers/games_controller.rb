class GamesController < ApplicationController
  before_action :authorise
  before_action :find_game, only: [:edit, :update, :destroy]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    success = Game.new(game_params).save
    success &= Game.new(reverse_params).save if reverse_params[:result]

    redirect_to games_path,
      notice: success ? t(:created_game) : t(:create_game_failed)
  end

  def edit
  end

  def update
    if @game.update_attributes(game_params)
      redirect_to games_path, notice: t(:updated_game)
    else
      flash.now.alert = t(:update_game_failed)
      render :edit
    end
  end

  def destroy
    redirect_to games_path,
      notice: @game.destroy ? t(:deleted_game) : t(:delete_game_failed)
  end

  private

  def game_params
    params.require(:game).permit(:corp_id, :runner_id, :result)
  end

  def reverse_params
    game_params.tap do |p|
      p[:corp_id], p[:runner_id] = p[:runner_id], p[:corp_id]
      p[:result] = params[:reverse_result]
    end
  end

  def find_game
    @game = Game.find(params[:id])
  end
end
