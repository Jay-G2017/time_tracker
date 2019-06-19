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

        result = {success: true}
        render result
      end
    end

  end
end
