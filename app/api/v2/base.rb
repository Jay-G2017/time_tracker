module V2
  class Base < Grape::API
    version ['v2'], using: :path
    mount V2::Projects
  end
end
