class Main < Grape::API
  prefix 'api'
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  error_formatter :json, Grape::Formatter::ActiveModelSerializers
  mount V2::Base
  mount V1::Base

  if Rails.env.development?
    add_swagger_documentation(
      format: :json,
      mount_path: "/doc",
      info: { title: "tomato-todo-API" }
    )
  end
end
