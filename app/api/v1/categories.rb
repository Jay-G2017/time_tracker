module V1
  class Categories < Grape::API
    namespace :categories do
      desc '获取一个projects'
      params do
        requires :id, type: Integer, desc: 'category id'
      end
      get ":id/projects" do
        category = Category.find params[:id]
        projects = category.projects

        render projects, include: 'titles.todos'
      end
    end
  end
end
