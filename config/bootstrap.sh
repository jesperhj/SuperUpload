#!/bin/bash
#
# Ubuntu 10.04 
# ami from http://cloud-images.ubuntu.com/releases/10.04/release/
################################################################################
echo "###########################################################"
echo "Update repository list"
echo "###########################################################"
apt-get update;
apt-get -y upgrade;

echo "###########################################################"
echo "Install Emacs"
echo "###########################################################"
apt-get install -y emacs23-nox;

echo "###########################################################"
echo "Build essential"
echo "###########################################################"
apt-get install -y build-essential;


echo "###########################################################"
echo "NTP"
echo "###########################################################"
apt-get install -y ntp;

echo "###########################################################"
echo "Install Nginx as Webserver"
echo "###########################################################"
# Use 1.0.x instead of 0.7.x of nginx.
add-apt-repository ppa:nginx/stable;
apt-get update;
apt-get install -y nginx;

echo "###########################################################"
echo "Install Ruby 1.8.7"
echo "###########################################################"
apt-get install -y ruby1.8;
apt-get install -y ruby1.8-dev;
apt-get install -y ruby;

echo "###########################################################"
echo "Manual install rubygems"
echo "###########################################################"
wget -P /tmp http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar -C /tmp/ -zxvf /tmp/rubygems-1.8.10.tgz
ruby /tmp/rubygems-1.8.10/setup.rb
ln -s /usr/bin/gem1.8 /usr/local/bin/gem

echo "###########################################################"
echo "Install extra packages needed by Ruby and its gems"
echo "###########################################################"
apt-get install -y rdoc1.8;
apt-get install -y libsinatra-ruby1.8;
apt-get install -y libxml2-dev;
apt-get install -y libxslt1-dev;
apt-get install -y zip;
apt-get install -y libcurl4-openssl-dev;
apt-get install -y libopenssl-ruby;
apt-get install -y irb;

echo "###########################################################"
echo "System gems"
echo "###########################################################"
gem install bundler -v 1.1.3 --no-ri --no-rdoc;

echo "###########################################################"
echo "Not Install Thin - use bundle exec thin instead"
echo "###########################################################"
mkdir /etc/thin;

echo "###########################################################"
echo "Git"
echo "###########################################################"
apt-get install -y git-core;

echo "###########################################################"
echo "Fix owner and permissions"
echo "###########################################################"
chown -R ubuntu:ubuntu /home/ubuntu/.gem;

echo "###########################################################"
echo "Now you have to do:"
echo "###########################################################"
echo "# Deploy super_upload"

echo "CRONJOBS for deleting old files"
echo "10 * * * * find /tmp/uploader_file* -mtime +1 -exec rm {} \;"