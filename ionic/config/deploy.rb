# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'Ionic'
set :repo_url, 'git@github.com:wtfiwtz/ionic.git'
set :rails_env, 'staging'
#set :pty, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/ionic'

# Default value for :scm is :git
set :scm, :git

set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml db/staging.sqlite3 config/secrets.yml config/environments/staging.rb config/environments/production.rb config/initializers/secret_token.rb}

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :bundle_binstubs, nil

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart nginx'
  task :restart do
    on roles(:app), in: :sequence, wait: 1 do
      execute :sudo, 'service nginx restart'
    end
  end

end

after 'deploy:publishing', 'deploy:restart'
