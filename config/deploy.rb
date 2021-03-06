# config valid only for current version of Capistrano
lock '3.4.0'

#config=YAML.load_file('config/secrets.yml')
set :application, 'radar'
set :repo_url, "git@bitbucket.org:romeuhcf/radar.git"
set :deploy_to, "/home/deploy/vhosts/mailergrid2.#{fetch(:stage)}"
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :passenger_restart_with_touch, true
set :bundle_binstubs, -> { shared_path.join('bin') }            # default: nil
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
task :create_uploads_links do
  puts "doing"
  on roles(:web) do
  puts "doing one"
    execute "mkdir -p /mnt/storage/var/mailergrid/#{fetch(:stage)}/2/uploads"
    execute "mkdir -p #{shared_path}/public"
    execute "rmdir  #{shared_path}/public/uploads || true"
    execute "test -L #{shared_path}/public/uploads || ln -sf  /mnt/storage/var/mailergrid/#{fetch(:stage)}/2/uploads #{shared_path}/public/uploads"
  end
end

namespace :deploy do
  before :restart, :create_uploads_links
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
