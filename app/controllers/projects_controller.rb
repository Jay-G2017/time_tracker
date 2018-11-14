class ProjectsController < ApplicationController
  before_action :require_login

  def first_load
    @categories = current_user.categories
    pinned_projects = current_user.pinned_projects
    if pinned_projects.present?
      @projects = pinned_projects
      @category_type = 'pinned'
    else
      @projects = current_user.inbox_projects
      @category_type = 'inbox'
    end
    @category_id = 0

    render 'index', layout: 'time_tracker'
  end

  def index
    category = Category.find_by(id: params[:category_id])

    if category
      @projects = category.projects
      @category_id = category.id
      @category_type = nil
    else
      case params[:category_type]
      when 'inbox'
        @projects = current_user.inbox_projects
        @category_type = 'inbox'
      when 'pinned'
        @projects = current_user.pinned_projects
        @category_type = 'pinned'
      when 'done'
        @projects = current_user.done_projects
        @category_type = 'done'
      end
      @category_id = 0
    end

    render partial: 'project_sidebar'
  end

  def show
    project = Project.includes(titles: :todos).find params[:id]
    render partial: 'project', locals: { project: project }
  end

  def edit
    project = Project.find params[:id]

    render partial: 'edit', locals: { project: project }
  end

  def update
    project = Project.find params[:id]
    project.update!(project_params)

    render json: project
  end

  def create
    category = Category.find_by(id: params[:category_id])
    if category.nil? && category_type == 'inbox'
      project = Project.create!(project_params)
    else
      project = category.projects.create!(project_params)
    end

    render partial: 'project_list', locals: { project: project }
  end

  def destroy
    project = Project.find params[:id]
    project.destroy!

    render json: { success: true }
  end

  private
  def require_login
    if !current_user || (current_user.login_at < 12.hours.ago ) #12小时登录过期
      session[:to_url] = request.original_url if !request.xhr?
      redirect_to log_in_url, notice: '请先登录你的帐户!'
    end
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
