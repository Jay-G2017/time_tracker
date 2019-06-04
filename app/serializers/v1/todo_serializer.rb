module V1
  class TodoSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
