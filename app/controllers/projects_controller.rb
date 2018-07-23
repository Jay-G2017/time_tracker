class ProjectsController < ApplicationController
  def index
    @categories = Category.includes(:projects).all
    @active_show_project = Project.first
  end

  def show
    project = Project.find params[:id]
    render partial: 'project', locals: { project: project }
  end
end
