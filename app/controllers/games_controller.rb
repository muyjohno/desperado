class GamesController < ApplicationController
  before_action :authorise

  def index
    @filters = filter_params
    @games = Game.by_week.where(@filters).page(page_param).per(20)
  end

  def new
    redirect_to games_path, notice: t(:no_players_exist) if Player.count < 2

    @game = Game.new
  end

  def create
    success = handle_game
    success &= handle_reverse unless reverse_params[:result].blank?

    redirect_to games_path,
      notice: success ? t(:created_game) : t(:create_game_failed)
  end

  def edit
    @game = find_game
  end

  def update
    @game = find_game
    if @game.update_attributes(game_params) && update_achievements
      redirect_to games_path, notice: t(:updated_game)
    else
      flash.now.alert = t(:update_game_failed)
      render :edit
    end
  end

  def destroy
    @game = find_game
    redirect_to games_path,
      notice: @game.destroy ? t(:deleted_game) : t(:delete_game_failed)
  end

  private

  def handle_game(params = game_params, key = :achievements)
    game = Game.new(params)
    game.save && update_achievements(game, key)
  end

  def handle_reverse
    handle_game(reverse_params, :reverse_achievements)
  end

  def update_achievements(game = @game, key = :achievements)
    return true unless params[key]

    params[key].each do |id, earned|
      if earned == "1"
        game.add_achievement(Achievement.find(id))
      else
        game.remove_achievement(Achievement.find(id))
      end
    end
    true
  end

  def game_params
    params.require(:game).permit(:corp_id, :runner_id, :result, :week)
  end

  def reverse_params
    game_params.tap do |p|
      p[:corp_id], p[:runner_id] = p[:runner_id], p[:corp_id]
      p[:result] = params[:reverse_result]
    end
  end

  def find_game
    Game.find(params[:id])
  end

  def page_param
    params[:page] || 1
  end

  def filter_params
    params.fetch(:filter) do
      return {}
    end.permit(:week, :corp_id, :runner_id).reject { |_, v| v.blank? }
  end
end
