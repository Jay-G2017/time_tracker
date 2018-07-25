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
    if !current_user
      redirect_to log_in_url, notice: '请先登录你的帐户!'
    end
  end
end
