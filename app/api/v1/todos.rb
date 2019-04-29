module V1
  class Todos < Grape::API
    namespace :todos do
      desc '删除一个project'
      params do
        requires :id, type: Integer, desc: 'todo id'
      end
      delete ":id" do
        todo = Todo.find params[:id]
        todo.destroy!

        project = todo.project

        render project, include: 'titles.todos'
      end
    end

  end
end
