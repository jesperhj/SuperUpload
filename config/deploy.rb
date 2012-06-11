require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'erb'

set :application, "super_upload"
set :deploy_to, "/srv/apps/#{application}"

set :scm, "git"
set :repository,  "git@github.com:jesperhj/SuperUpload.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "ubuntu"
set :ssh_options, { 
  :forward_agent => true, 
  :keys => ["#{ENV['HOME']}/.ssh/vfm_test.pem"]
}

after 'deploy:update', 'deploy:cleanup'
after 'deploy:setup', 'deploy:correct_permissions', 'uploader:setup_server'
after 'bundle:install', 'uploader:thin_files'


namespace :uploader do
  task :thin_files do
    run "cp #{release_path}/thin/* #{shared_path}/bundle/ruby/1.8/gems/thin-1.3.1/lib/thin"
  end
  
  task :setup_server do
    top.upload('config/super_upload', '/tmp/super_upload', :via => :scp)
    run "sudo cp /tmp/super_upload /etc/init.d/super_upload"
    run "sudo chmod 755 /etc/init.d/super_upload"
    run "sudo /usr/sbin/update-rc.d super_upload defaults"
    
    top.upload('config/super_upload.thin', '/tmp/super_upload.thin', :via => :scp)
    run "sudo cp /tmp/super_upload.thin /etc/thin/super_upload.thin"
  end
end