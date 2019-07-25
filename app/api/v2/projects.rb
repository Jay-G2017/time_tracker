module V2
  class Projects < Grape::API
    namespace :projects do
      desc '获取一个project'
      params do
        requires :id, type: Integer, desc: 'project id'
      end
      get ":id" do
        project = Project.find params[:id]

        render project, include: 'todos,titles.todos'
      end

    end

  end
end
