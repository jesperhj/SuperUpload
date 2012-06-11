# Deployes for
# sunshine.test.videofy.me  : uses mock database
role :app, "ec2-79-125-48-205.eu-west-1.compute.amazonaws.com"

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
end