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
        title.todos.create!(name: params[:name])

        project = title.project

        render project, include: 'titles.todos'
      end
    end
  end
end
