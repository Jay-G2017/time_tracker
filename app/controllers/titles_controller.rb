class TitlesController < ApplicationController
  def new
    @project = Project.find params[:project_id]
    @title = Title.new
    render partial: 'new'
  end

  def edit
    @project = Project.find params[:project_id]
    @title = Title.find params[:id]
    render partial: 'edit'
  end

  def update
    project = Project.find params[:project_id]
    title = Title.find params[:id]
    title.update!(title_params)
    render partial: 'shared/title_show', locals: { project: project, title: title }
  end

  def create
    project = Project.find params[:project_id]
    title = project.titles.create!(title_params)
    render partial: 'shared/title_show', locals: { project: project, title: title }
  end

  def destroy
    title = Title.find params[:id]
    title.destroy!
    render json: { success: true }
  end

  private
  def title_params
    params.require(:title).permit(:name)
  end
end
