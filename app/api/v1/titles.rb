module V1
  class Titles < Grape::API
    namespace :titles do
      desc 'add a todo'
      params do
        requires :id, type: Integer, desc: 'title id'
        requires :name, type: String, desc: 'todo content'
      end

      post ":id/todos" do
        title = Title.find params[:id]
        todo = title.todos.build(name: params[:name])
        project = title.project
        todo.project = project
        todo.save

        render project, include: 'titles.todos'
      end
    end
  end
end
