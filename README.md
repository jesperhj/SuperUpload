SuperUpload
===========

INSTALL
-------
upload config/bootstrap.sh to server and run
sudo sh bootstrap.sh

Install gems locally
bundle install --path vendor

Change servername in config/super_upload.nginx_

Prepare server for deploy
bundle exec cap aws deploy:setup

Check that everything went well
bundle exec cap aws deploy:check

Deploy
bundle exec cap aws deploy

Iframe uploader for IE>6, FF and Chrome 