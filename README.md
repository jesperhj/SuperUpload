# SuperUpload #

Sinatra app with patches to thin to allow upload with progress.

A hidden iframe is used to be able to do the upload in the background.
Each upload gets a unique id from the server, which is used to identify the information of the upload.
With the help of Ajax, the server is pulled each second to check the status of the upload.
Thin [0] is used as a webserver hosting the Sintra app. When Thin receives the POST request
from the site, it creates a temporary file, containing the content length of the request as well as the, original filename
.
When the server is pulled to check status of the upload, it checks the file, created by Thin, to get content length and original name. With that info it can then check how big the temporary file is and return the percent or check if the file is located in the destination folder.

When posting the description, the same unique id is used to inform the server which title and path it wants to get in the response.

The project is written with as little dependencies as possible in mind.
Nginx nor Apache is needed. Although one could use Nginx to work as a load balancer proxying to thin. With this
setup one could host several thin instances to serve more requests.
No Javascript library like jQuery, MooTools or Prototype is used. They could would most likely make the js code more beautiful, but as to not use any dependencies, they have been left out.

Was first thinking about using a memory table in MySQL instead of the temporary files to store the content-length and other data. But as to keep the solution simple, I chose to go with the temporary files.

As backend is more my cup of tea, I thought about using Bootstrap [1] to beautify the page, but as this would require a dependency, I chose to go with the "raw" look.

[0] : http://code.macournoyer.com/thin/

[1] : http://twitter.github.com/bootstrap/

# INSTALL #

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