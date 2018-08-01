class TitlesController < ApplicationController
  def new
    @project = Project.find params[:project_id]
    @title = Title.new
    render partial: 'new'
  end
end
