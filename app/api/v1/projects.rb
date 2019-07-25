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

      desc '创建一个todo, 参数title_id可不传, 如果不传就建在project下'
      params do
        requires :id, type: Integer, desc: 'project id'
        requires :name, type: String, desc: 'todo name'
        optional :title_id, type: String, desc: 'title id'
      end
      post ":id/todos" do
        project = Project.find params[:id]
        title_id = params[:title_id]
        title = project.titles.where(id: title_id).first
        if title.present?
          todo = title.todos.build(name: params[:name])
          todo.project = project
          todo.save!
        else
          project.todos.create!(name: params[:name])
        end

        result = {success: true}
        render result
      end
    end

  end
end
