class TomatoesController < ApplicationController
  def create
    todo = Todo.find params[:todo_id]
    todo.tomatoes.create!(tomato_params)

    render json: { success: true }
  end

  private
  def tomato_params
    params.permit(:minutes)
  end
end
