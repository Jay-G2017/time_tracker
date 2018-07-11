# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "time_tracker"
set :repo_url, "git@github.com:Jay-G2017/time_tracker.git"

set :rvm_ruby_version, '2.4.1'
set :rvm_custom_path, '/usr/share/rvm'

append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache'

namespace :deploy do
  task :start do
    on roles(:app) do
      execute %{source /etc/profile.d/rvm.sh && cd #{current_path} && if [ ! -f #{fetch(:pid_file)} ]; then UNICORN_WORKER_NUM=#{fetch(:unicorn_worker_num)} RAILS_ENV=#{fetch(:rails_env)} APP_PORT=#{fetch(:listen_port)} SERVER_STAGE=#{fetch(:server_stage)} bundle exec unicorn -c #{fetch(:unicorn_config_file)} -D; fi}
    end
  end

  task :stop do
    on roles(:app) do
      execute %{source /etc/profile.d/rvm.sh && cd #{current_path} && if [ -f #{fetch(:pid_file)} ] && kill -0 `cat #{fetch(:pid_file)}`> /dev/null 2>&1; then kill -QUIT `cat #{fetch(:pid_file)}`; else rm #{fetch(:pid_file)} || exit 0; fi}
    end
  end

  task :restart do
    on roles(:app) do
      execute %{source /etc/profile.d/rvm.sh && cd #{current_path} && if [ -f #{fetch(:pid_file)} ] && kill -0 `cat #{fetch(:pid_file)}`> /dev/null 2>&1; then kill -HUP `cat #{fetch(:pid_file)}`; else rm #{fetch(:pid_file)} || source ~/.nvm/nvm.sh && SKIP_DATA_LOAD=false UNICORN_WORKER_NUM=#{fetch(:unicorn_worker_num)} RAILS_ENV=#{fetch(:env)} APP_PORT=#{fetch(:listen_port)} SERVER_STAGE=#{fetch(:server_stage)} bundle exec unicorn -c #{fetch(:unicorn_config_file)} -D; fi}
    end
  end
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
