class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # 可否跳到相应的url, 而不是写死的.
      redirect_to root_url, :notice => 'Logged in!'
    else
      flash.now.alert = "帐户或密码错误!"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to log_in_url, :notice => 'Logged out!'
  end
end
