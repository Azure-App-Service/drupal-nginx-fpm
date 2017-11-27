#!/bin/bash

set -e

php -v

# setup nginx log dir
# http://nginx.org/en/docs/ngx_core_module.html#error_log
sed -i "s|error_log /var/log/nginx/error.log;|error_log stderr;|g" /etc/nginx/nginx.conf

# setup server root
mkdir -p "$DRUPAL_HOME"
chown -R www-data:www-data "$DRUPAL_HOME/"

# create index.html
test -d "${DRUPAL_HOME}/index.html" && rm ${DRUPAL_HOME}/index.html 
echo '<html><head><meta http-equiv="refresh" content="30" /><meta http-equiv="pragma" content="no-cache" /><meta http-equiv="cache-control" content="no-cache" /><title>Installing Drupal</title></head><body>Installing Drupal ... This could be done in minutes. <p>Please refresh your browser and go to  http://[website]/index.php later.</p></body></html>' > ${DRUPAL_HOME}/index.html 

cd $DRUPAL_SOURCE 
tar -xf drupal.tar.gz -C $DRUPAL_HOME/ --strip-components=1 
chmod a+w "$DRUPAL_HOME/sites/default" 
mkdir -p "$DRUPAL_HOME/sites/default/files"
chmod a+w "$DRUPAL_HOME/sites/default/files"
cp "$DRUPAL_HOME/sites/default/default.settings.php" "$DRUPAL_HOME/sites/default/settings.php"
chmod a+w "$DRUPAL_HOME/sites/default/settings.php"
cd $DRUPAL_HOME
rm -rf $DRUPAL_SOURCE

echo "Starting SSH ..."
service ssh start

echo "Starting php-fpm ..."
service php7.0-fpm start

echo "Starting Nginx ..."
/usr/sbin/nginx


