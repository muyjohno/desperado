class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: t(:login_success)
    else
      flash.now.alert = t(:login_failure)
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t(:logout_success)
  end
end
