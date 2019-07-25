module V2
  class ProjectSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :todos do 
      object.todos.where(title_id: nil)
    end

    has_many :titles
  end
end
