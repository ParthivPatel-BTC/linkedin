# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'linkedin-scraper'
set :repo_url, 'git@github.com:ParthivPatel-BTC/linkedin.git'
set :deploy_to, '/home/shailesh/linkedin'
set :stage, :production
set :user, 'shailesh'
set :pty, true
set :use_sudo, true
set :deploy_via, :remote_cache

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :branch, 'master' #set/ :branch,`git rev-parse --abbrev-ref HEAD`.chomp
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_new_rsa.pub) }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end