# Deployes for
# sunshine.test.videofy.me  : uses mock database
role :app, "ec2-79-125-48-205.eu-west-1.compute.amazonaws.com"

set :branch, "master"

namespace :deploy do
  [:restart, :start, :stop].each do |t|
    desc "#{t} thin"
    task t do
      sudo "service super_upload #{t}"
    end
  end

  desc "Correct permissions"
  task :correct_permissions do
    sudo "chown -R ubuntu:ubuntu /srv/apps/#{application}"
  end
  
  task :thin_files do
    run "cp #{release_path}/thin/* #{shared_path}/bundle/ruby/1.8/gems/thin-1.3.1/lib/thin"
  end
  
  task :setup_server do
    upload(File.dirname(__FILE__)+'../super_upload', '/tmp/super_upload', :via => :scp)
    run "sudo cp /tmp/super_upload /etc/init.d/super_upload"
    run "sudo chmod 755 /etc/init.d/super_upload"
    run "sudo /usr/sbin/update-rc.d super_upload defaults"
    
    upload(File.dirname(__FILE__)+'../super_upload.thin', '/tmp/super_upload.thin', :via => :scp)
    run "sudo cp /tmp/super_upload.thin /etc/thin/super_upload.thin"
    
    upload(File.dirname(__FILE__)+'../nginx.conf', '/tmp/nginx.conf', :via => :scp)
    run "sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf"
    
    upload(File.dirname(__FILE__)+'../super_upload.nginx', '/tmp/super_upload.nginx')
    run "sudo cp /tmp/super_upload.nginx /etc/nginx/super_upload.nginx"
    run "sudo ln -s /etc/nginx/sites-available/super_upload.nginx /etc/nginx/sites-enabled/super_upload.nginx"
    run "sudo service super_upload start"
  end
end