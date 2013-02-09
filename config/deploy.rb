#
# Put here shared configuration shared among all children
#
# Read more about configurations:
# https://github.com/railsware/capistrano-multiconfig/README.md

# Configuration example for layout like:
# config/deploy/{NAMESPACE}/.../#{PROJECT_NAME}/{STAGE_NAME}.rb

set :application, "awesome"
set :user, "deployer"
set :group, "deployer"
set :use_sudo, false
set :keep_releases, 4

# Forward the user's SSH Agent (so we don't need deployer keys)
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV['HOME'], ".ssh", "#{user}")]

# Don't touch the asset files under public/
set :normalize_asset_timestamps, false

# Git Repository
set :scm, :git
set :repository, "git://github.com/whoward/awesome.git"
set :branch, :master unless exists?(:branch)

set :deploy_via, :remote_cache

set :rails_env, :production

set(:deploy_to) { "/home/deployer/apps/#{application}" }

server "rackspace", :app, :web, :db, :primary => true

# Bundler integration
require 'bundler/capistrano'

# RVM integration
require "rvm/capistrano"
set :rvm_path, "/usr/local/rvm"
set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_ruby_string, "ruby-1.9.3"

after "deploy:update_code", "deploy:configs"
after "deploy:update_code", "deploy:game"

namespace :deploy do
   desc "Symlink configuration files"
   task :configs do
      run "ln -sf #{shared_path}/mongoid.yml #{release_path}/config/mongoid.yml"
   end

   desc "Installs the game data files"
   task :game do
      run "ln -sf #{shared_path}/game.json #{release_path}/game.json"
   end
end
