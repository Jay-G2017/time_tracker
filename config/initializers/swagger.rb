if Rails.env.development?
  GrapeSwaggerRails.options.url      = '/api/doc.json'
  GrapeSwaggerRails.options.app_name = 'tomato-todo-api'
  GrapeSwaggerRails.options.before_action { GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port }
end
