#!/bin/bash

set -e

# Stop Nginx
service nginx stop

# Check if database.sqlite exists, and create it if it doesn't
if [ ! -f /home/site/wwwroot/database/database.sqlite ]; then
touch /home/site/wwwroot/database/database.sqlite
chmod 666 /home/site/wwwroot/database/database.sqlite
fi

# Set correct permissions
chmod -R 775 /home/site/wwwroot/storage
chmod -R 775 /home/site/wwwroot/bootstrap/cache
chown -R www-data:www-data /home/site/wwwroot/storage
chown -R www-data:www-data /home/site/wwwroot/bootstrap/cache

# Run database migrations and seeders
php /home/site/wwwroot/artisan migrate --force
php /home/site/wwwroot/artisan db:seed --force

# Clear and cache Laravel configurations
php /home/site/wwwroot/artisan cache:clear
php /home/site/wwwroot/artisan config:clear
php /home/site/wwwroot/artisan config:cache
php /home/site/wwwroot/artisan route:clear
php /home/site/wwwroot/artisan view:clear

# Copy default Nginx configuration from the deployed project
if [ -f /home/site/wwwroot/routes/default ]; then
	cp /home/site/wwwroot/routes/default /etc/nginx/sites-available/default
elif [ -f /home/site/wwwroot/default ]; then
	cp /home/site/wwwroot/default /etc/nginx/sites-available/default
else
	echo "Nginx config file not found in /home/site/wwwroot/routes/default or /home/site/wwwroot/default"
	exit 1
fi

ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
nginx -t

# Start Nginx
service nginx start