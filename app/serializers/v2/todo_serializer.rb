module V2
  class TodoSerializer < ActiveModel::Serializer
    attributes :id, :name, :done
  end
end
