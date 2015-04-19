set :application, "docnhanh"

set :rvm_ruby_string, 'ruby-2.0.0-p643@docnhanh'
set :rvm_type, :system # defaults to using a user installation of rvm

# set :ssh_options, { forward_agent: true, keys: ['~/.ssh/cardrive']  }
set :branch, "master"
set :rails_env, "production"

set :host_name, "128.199.103.139"

role :web, host_name                # Your HTTP server, Apache/etc
role :app, host_name                # This may be the same as your `Web` server
role :db,  host_name, primary: true # This is where Rails migrations will run