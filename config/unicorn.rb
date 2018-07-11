APP_PORT ||= ENV['APP_PORT'] || 3000
puts "app_port: #{APP_PORT}"
APP_PATH = ENV['WORKING_DIRECTORY'] || File.expand_path('../..', __FILE__)
puts "working_directory: #{APP_PATH}"
PID_PATH = ENV['PID_PATH'] || (APP_PATH + "/tmp/pids/unicorn.pid")
puts "pid_path: #{PID_PATH}"
WORKER_NUM = ENV['WORKER_NUM'] || 2
puts "worker_num: #{WORKER_NUM}"

listen APP_PORT, :tcp_nopush => true
working_directory APP_PATH
pid PID_PATH
worker_processes WORKER_NUM.to_i

timeout 7200

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{APP_PATH}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
