lock "~> 3.17.1"

set :application, "theturtlefoundation"
set :repo_url, "git@github.com:papayalabs/theturtlefoundation.git"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'certs'
append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/aws.yml', 'config/unicorn.rb'

set :whenever_environment, -> { "#{fetch(:stage)}" }
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/theturtlefoundation"
set :unicorn_config_path, "/var/www/theturtlefoundation/shared/config/unicorn.rb"

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

#namespace :deploy do
#    desc 'Restart application'
#    task :restart do
#      on roles(:app), in: :sequence, wait: 5 do
#        execute :touch, release_path.join('tmp/restart.txt')
#      end
#    end
  
#    after :published, 'deploy:restart'
#    after :finishing, 'deploy:cleanup'
#  end

namespace :unicorn do
  desc 'Stop application'
  task :stop do
    on roles(:app) do
      puts "Stoping Unicorn..."
      sudo "kill -9 $(pgrep -f #{fetch(:unicorn_config_path)} )"
    end
  end
end

namespace :unicorn do
    desc 'Start application'
    task :start do
      on roles(:app) do
        puts "Starting Unicorn..."
        execute "cd #{fetch(:deploy_to)}/current/"; "bundle exec unicorn -c #{fetch(:unicorn_config_path)} -E production -D"
      end
    end
end

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end