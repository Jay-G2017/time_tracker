class TodosController < ApplicationController
  def new
    @title = Title.find params[:title_id]
    @todo = Todo.new
    render partial: 'new'
  end

end
