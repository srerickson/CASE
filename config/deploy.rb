#require 'thinking_sphinx/deploy/capistrano'

set :rvm_ruby_string, '1.9.2@rails3'
set :application, "boi-cms-2.0"
set :repository,  "git://github.com/srerickson/CASE"
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :scm, :git
set :keep_releases, 5
set :user, "capistrano"
set :use_sudo, false
set :bundle_without,  [:development]

role :web, "birds.recursivepublic.net"                          # Your HTTP server, Apache/etc
role :app, "birds.recursivepublic.net"                          # This may be the same as your `Web` server
role :db,  "birds.recursivepublic.net", :primary => true # This is where Rails migrations will run

namespace :deploy do

  task :bundle_gems do 
    run "ln -s #{deploy_to}/shared/vendor/gems #{deploy_to}/current/vendor/gems"
    run "cd #{deploy_to}/current && bundle install --path=vendor/gems"
  end
  
  task :link_database_config do
    run "ln -s #{deploy_to}/shared/config/database.yml #{deploy_to}/current/config/"
  end
  

  # start, stop and restart for Passenger standalone
	task :start, :roles => :app do
	  run "cd #{current_path};passenger start -a 127.0.0.1 -p 3000 -d -e production"
	end

	task :stop, :roles => :app do
	  run "kill -QUIT `cat #{current_path}/tmp/pids/passenger.3000.pid`"
	end
	
	task :restart, :roles => :app do
	  run "touch #{current_path}/tmp/restart.txt"
	end
end


# task :pull_db do
#   taps_user = `uuidgen`.strip
#   taps_pass = `uuidgen`.strip
# 
#   run "nohup #{deploy_to}/taps_ctrl.sh start #{taps_user} #{taps_pass} > #{deploy_to}/taps.log 2>&1 ", :pty => true
#   set(:user) do
#     Capistrano::CLI.ui.ask "Give me local DB user: "
#   end
#   set(:pass) do
#     Capistrano::CLI.ui.ask "Give me local DB pass: "
#   end
#   system("bundle exec taps pull mysql2://#{user}:#{pass}@localhost/boi http://#{taps_user}:#{taps_pass}@limn.it:5000")
#   run "#{deploy_to}/taps_ctrl.sh stop"
# end


after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:link_database_config"
after "deploy:link_database_config", "deploy:restart"


require 'rvm/capistrano'

