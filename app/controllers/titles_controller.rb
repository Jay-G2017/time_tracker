class TitlesController < ApplicationController
  def new
    @project = Project.find params[:project_id]
    @title = Title.new
    render partial: 'new'
  end

  def create
    @project = Project.find params[:project_id]
    @title = @project.titles.create!(title_params)
    render partial: 'show'
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
