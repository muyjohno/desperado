class UsersController < ApplicationController
  before_action :authorise

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to root_path, notice: t(:updated_password)
    else
      flash.now.alert = t(:update_password_failed)
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
