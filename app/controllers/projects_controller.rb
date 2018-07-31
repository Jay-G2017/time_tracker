class ProjectsController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.includes(:projects).all
    @active_show_project = Project.first
  end

  def show
    project = Project.find params[:id]
    render partial: 'project', locals: { project: project }
  end

  private
  def require_login
    if !current_user || (current_user.login_at > 12.hours.ago ) #12小时登录过期
      session[:to_url] = request.original_url if !request.xhr?
      redirect_to log_in_url, notice: '请先登录你的帐户!'
    end
  end
end
