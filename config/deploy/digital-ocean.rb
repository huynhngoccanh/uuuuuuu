# Settings for staging server
server '159.65.33.189', :app, :web, :db, :primary => true
set :rails_env, 'production'

set :use_sudo, false
set :deploy_via, :remote_cache
set :user, 'ubiuser'
set :repository,  'git@github.com:miclabs/ubitru.git'
set :branch, "staging"
# set :rvm_ruby_version, 'ruby-2.1.0'
set :deploy_to, "/home/#{user}/#{application}"
# set :branch, 'ubitru'
