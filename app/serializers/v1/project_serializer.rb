module V1
  class ProjectSerializer < ActiveModel::Serializer
    attributes :id, :name
    has_many :titles
  end
end
