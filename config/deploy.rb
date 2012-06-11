require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'erb'


set :application, "super_upload"
set :deploy_to, "/srv/apps/#{application}"

set :scm, "git"
set :repository,  "git@github.com:jesperhj/SuperUpload.git"
set :branch, "master"
#set :deploy_via, :remote_cache

set :user, "ubuntu"
set :ssh_options, { 
  :forward_agent => true, 
  :keys => ["#{ENV['HOME']}/.ssh/vfm_test.pem"]
}

after 'deploy:update', 'deploy:cleanup'
after 'deploy:setup', 'deploy:correct_permissions'
after 'bundle:install', 'deploy:thin_files'