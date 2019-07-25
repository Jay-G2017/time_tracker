module V2
  class TitleSerializer < ActiveModel::Serializer
    attributes :id, :name
    has_many :todos, serializer: TodoSerializer
  end
end
