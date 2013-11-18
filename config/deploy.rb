# Deploy script from Railscasts
require "bundler/capistrano"

# Public  IP: 23.23.22.11
# Private IP: 10.165.8.169
server "23.23.22.11", :web, :app, :db, primary: true

set :application, "kanari"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:Kanari-HQ/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end













#=== OLD deploy script for Linode

#require 'bundler/capistrano'
 
# This capistrano deployment recipe is made to work with the optional
# StackScript provided to all Rails Rumble teams in their Linode dashboard.
#
# After setting up your Linode with the provided StackScript, configuring
# your Rails app to use your GitHub repository, and copying your deploy
# key from your server's ~/.ssh/github-deploy-key.pub to your GitHub
# repository's Admin / Deploy Keys section, you can configure your Rails
# app to use this deployment recipe by doing the following:
#
# 1. Add `gem 'capistrano', '~> 2.15'` to your Gemfile.
# 2. Run `bundle install --binstubs --path=vendor/bundles`.
# 3. Run `bin/capify .` in your app's root directory.
# 4. Replace your new config/deploy.rb with this file's contents.
# 5. Configure the two parameters in the Configuration section below.
# 6. Run `git commit -a -m "Configured capistrano deployments."`.
# 7. Run `git push origin master`.
# 8. Run `bin/cap deploy:setup`.
# 9. Run `bin/cap deploy:migrations` or `bin/cap deploy`.
#
# Note: You may also need to add your local system's public key to
# your GitHub repository's Admin / Deploy Keys area.
#
# Note: When deploying, you'll be asked to enter your server's root
# password. To configure password-less deployments, see below.
 
#############################################
##                                         ##
##              Configuration              ##
##                                         ##
#############################################

#GITHUB_REPOSITORY_NAME = 'r13-team-369'
#LINODE_SERVER_HOSTNAME = '173.255.248.33'
#
##############################################
##############################################
#
## General Options
#
#set :bundle_flags,               "--deployment"
#
#set :application,                "railsrumble"
#set :deploy_to,                  "/var/www/apps/railsrumble"
#set :normalize_asset_timestamps, false
#set :rails_env,                  "production"
#
#set :user,                       "root"
#set :runner,                     "www-data"
#set :admin_runner,               "www-data"
#
## Password-less Deploys (Optional)
##
## 1. Locate your local public SSH key file. (Usually ~/.ssh/id_rsa.pub)
## 2. Execute the following locally: (You'll need your Linode server's root password.)
##
##    cat ~/.ssh/id_rsa.pub | ssh root@LINODE_SERVER_HOSTNAME "cat >> ~/.ssh/authorized_keys"
##
## 3. Uncomment the below ssh_options[:keys] line in this file.
##
## ssh_options[:keys] = ["~/.ssh/id_rsa"]
#
## SCM Options
#set :scm,        :git
#set :repository, "git@github.com:railsrumble/#{GITHUB_REPOSITORY_NAME}.git"
#set :branch,     "master"
#
## Roles
#role :app, LINODE_SERVER_HOSTNAME
#role :db,  LINODE_SERVER_HOSTNAME, :primary => true
#
## Add Configuration Files & Compile Assets
#after 'deploy:update_code' do
#  # Setup Configuration
#  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#
#  # Compile Assets
#  run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
#end
#
## Restart Passenger
#deploy.task :restart, :roles => :app do
#  # Fix Permissions
#  sudo "chown -R www-data:www-data #{current_path}"
#  sudo "chown -R www-data:www-data #{latest_release}"
#  sudo "chown -R www-data:www-data #{shared_path}/bundle"
#  sudo "chown -R www-data:www-data #{shared_path}/log"
#
#  # Restart Application
#  run "touch #{current_path}/tmp/restart.txt"
#end
#
#
#before "deploy:rollback:revision", "deploy:rollback_database"
#
#desc "Rolls back database to migration level of the previously deployed release"
#task :rollback_database, :roles => :db, :only => { :primary => true } do
#  if releases.length < 2
#    abort "could not rollback the code because there is no prior release"
#  else
#    rake = fetch(:rake, "rake")
#    rails_env = fetch(:rails_env, "production")
#    migrate_env = fetch(:migrate_env, "")
#    migrate_target = fetch(:migrate_target, :latest)
#    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} #{migrate_env} db:migrate VERSION=`cd #{File.join(previous_release, 'db', 'migrate')} && ls -1 [0-9]*_*.rb | tail -1 | sed -e s/_.*$//`"
#  end
#end