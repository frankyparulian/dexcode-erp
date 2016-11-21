# config valid only for Capistrano 3.1
lock '3.2.0'

set :application, 'dexcode_erp'
set :repo_url, 'git@bitbucket.org:aprimadi/dexcode-erp.git'

set :rvm_ruby_version, '2.1.5'

set :user, 'deploy'
set :use_sudo, false

set :deploy_to, '/var/deploy/dexcode-erp'
set :deploy_via, :remote_cache

set :scm, :git

set :linked_files, %w{.env env}
set :linked_dirs, %w{log tmp/cache tmp/sockets tmp/pids public/assets public/uploads}

set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :publishing, :restart
end

namespace :npm do
  desc 'Install npm dependency'
  task :install do
    on roles(:app) do
      within release_path do
        execute :npm, 'install'
      end
    end
  end
end

after "bundler:install", "npm:install"
after "deploy:restart", "resque:restart"
after "deploy:restart", "resque:scheduler:restart"
