class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.update(login_at: Time.now)
      to_url = session[:to_url] ? session[:to_url] : root_url
      redirect_to to_url, :notice => 'Logged in!'
      session[:to_url] = nil
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
