set :application, "docnhanh"

require "bundler/capistrano"
require "capistrano/ext/multistage"
require 'capistrano-unicorn'

set :scm, :git # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository,  "git@github.com:knguyen0105/docnhanh.git"
set :deploy_via, :copy
set :copy_strategy, :export
set :default_stage, :production

set :bundle_flags, "--deployment"
set :keep_releases, 10
set :use_sudo, false
set :install_gems, true
set :backup_database_before_migrations, true
set :bundle_without, [:development, :test]

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs

# before 'deploy:setup', 'rvm:install_rvm'  # install/update RVM
# before 'deploy:setup', 'rvm:install_ruby'
require "rvm/capistrano"


set(:unicorn_env) { rails_env }
set(:unicorn_config_file_path) { "#{current_path}/config/unicorn.rb" }
set(:unicorn_pid) { "/tmp/unicorn.#{application}.pid" }

set(:deploy_by_user) { 'deploy' }
set(:user) { 'deploy' }
set(:deploy_to) { "/home/deploy/#{application}" }

set :shared_children, shared_children + %w{public/img}

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end

after 'deploy:restart', 'unicorn:reload'    # appf IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)