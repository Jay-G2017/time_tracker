class TomatoesController < ApplicationController
  def create
    todo = Todo.find params[:todo_id]
    todo.tomatoes.create!(tomato_params)

    render json: { id: todo.id }
  end

  def today_tomatoes
    tomatoes = current_user.today_tomatoes
    result = []
    tomatoes.each do |tomato|
      result << { id: tomato.id, content: tomato.content, todo_name: tomato.todo.name,
                  minutes: tomato.minutes, created_at: tomato.created_at.strftime('%H:%M') }
    end

    render json: result
  end

  private
  def tomato_params
    params.permit(:minutes, :content)
  end
end
