# syntax=docker/dockerfile:1
FROM debian:buster

RUN apt-get update \
&& apt-get install nginx mariadb-server mariadb-client php php-mbstring php-zip php-gd php-xml php-net-socket php-bcmath unzip git php-gd php-xml-util php-pear php-gettext php-cgi wget php-fpm php-mysql -y \
&& service mysql start \
&& sleep 5 \
&& mysql -u root -e "CREATE DATABASE wpdb;" \
&& mysql -u root -e "CREATE USER 'tony'@localhost IDENTIFIED BY 'root';" \
&& mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'tony'@localhost IDENTIFIED BY 'root';" \
&& mysql -u root -e "FLUSH PRIVILEGES;" \
&& wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz \
&& mkdir /var/www/html/phpmyadmin \
&& tar xzf phpMyAdmin-5.1.0-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin \
&& cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php \
&& chmod 660 /var/www/html/phpmyadmin/config.inc.php \
&& chown -R www-data:www-data /var/www/html/phpmyadmin \
&& cd /var/www/html/ \
&& wget https://wordpress.org/latest.tar.gz \
&& tar -xvzf latest.tar.gz

ADD srcs /app

RUN cp /app/php.conf /var/www/html/phpmyadmin/config.inc.php \
&& cp /app/nginx.conf /etc/nginx/sites-enabled/default \
&& chmod u+x ./app/wait.sh

CMD ./app/wait.sh
