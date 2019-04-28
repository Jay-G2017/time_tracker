class Main < Grape::API
  prefix 'api'
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  error_formatter :json, Grape::Formatter::ActiveModelSerializers
  mount V1::Base
end
