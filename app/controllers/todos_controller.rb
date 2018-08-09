class TodosController < ApplicationController
  def edit
    title = Title.find params[:title_id]
    todo = Todo.find params[:id]
    render partial: 'edit', locals: { title: title, todo: todo }
  end

  def create
    title = Title.find params[:title_id]
    todo = title.todos.create!(todo_params)
    render partial: 'show', locals: { todo: todo }
  end

  def destroy
    todo = Todo.find params[:id]
    todo.destroy!
    render json: { success: true }
  end

  private
  def todo_params
    params.require(:todo).permit(:name)
  end

end
