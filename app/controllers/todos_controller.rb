class TodosController < ApplicationController
  def edit
    title = Title.find params[:title_id]
    todo = Todo.find params[:id]
    render partial: 'edit', locals: { title: title, todo: todo }
  end

  def update
    todo = Todo.find params[:id]
    todo.update!(todo_params)
    render json: todo
  end

  def create
    title = Title.find params[:title_id]
    todo = title.todos.create!(todo_params)
    render partial: 'show', locals: { title: title, todo: todo }
  end

  def destroy
    todo = Todo.find params[:id]
    todo.destroy!
    render json: { success: true }
  end

  def tomatoes_timeline
    todo = Todo.find params[:id]
    tomatoes = todo.tomatoes
    result = []
    tomatoes.each do |tomato|
      result << { id: tomato.id, content: tomato.content, todo_name: tomato.todo.name,
                  minutes: tomato.minutes, created_at: tomato.created_at.strftime('%H:%M') }
    end

    render json: result
  end

  private
  def todo_params
    params.require(:todo).permit(:name, :done)
  end

end
