class AchievementsController < ApplicationController
  before_action :authorise, except: :index

  def index
    @achievements = Achievement.all
  end

  def manage
    @achievements = Achievement.all
  end

  def new
    @achievement = Achievement.new
  end

  def create
    if Achievement.new(achievement_params).save
      redirect_to manage_achievements_path, notice: t(:created_achievement)
    else
      flash.now.alert = t(:create_achievement_failed)
      render :new
    end
  end

  def edit
    @achievement = find_achievement
  end

  def update
    @achievement = find_achievement
    if @achievement.update_attributes(achievement_params)
      redirect_to manage_achievements_path, notice: t(:updated_achievement)
    else
      flash.now.alert = t(:update_achievement_failed)
      render :edit
    end
  end

  def destroy
    @achievement = find_achievement
    redirect_to achievements_path,
      notice: @achievement.destroy ? t(:deleted_achievement) : t(:delete_achievement_failed)
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :points, :side)
  end

  def find_achievement
    Achievement.find(params[:id])
  end
end
