require "bundler/capistrano"
require "capistrano/ext/multistage"
require "rvm/capistrano"
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
set :bundle_without, [:development, :test, :cucumber]

set(:unicorn_env) { rails_env }
set(:unicorn_config_file_path) { "#{current_path}/config/unicorn.rb" }
set(:unicorn_pid) { "/tmp/unicorn.#{application}.pid" }

set(:deploy_by_user) { application }
set(:user) { application }
set :deploy_to, "#{base_path}/#{application}"

set :shared_children, shared_children + %w{public/img}

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)