module V1
  class Projects < Grape::API
    namespace :projects do
      desc '获取一个project'
      params do
        requires :id, type: Integer, desc: 'project id'
      end
      get ":id" do
        project = Project.find params[:id]

        render project, include: 'titles.todos'
      end

      desc '创建一个todo'
      params do
        requires :id, type: Integer, desc: 'project id'
        requires :name, type: String, desc: 'todo name'
      end
      post ":id/todos" do
        project = Project.find params[:id]
        project.todos.create!(name: params[:name])

        result = {success: true}
        render result
      end
    end

  end
end
