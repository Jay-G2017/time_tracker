module V2
  class ProjectSerializer < ActiveModel::Serializer
    attributes :id, :name
    has_many :todos
  end
end
