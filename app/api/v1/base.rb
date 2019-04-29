module V1
  class Base < Grape::API
    version ['v1'], using: :path
    mount V1::Projects
    mount V1::Todos
    mount V1::Titles
  end
end
