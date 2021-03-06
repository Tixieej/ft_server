#Getting base image
FROM debian:buster

MAINTAINER rde-vrie

#Update & install
RUN apt-get update && apt-get install -y \
	nginx \
	default-mysql-server \
	php7.3 \
	php7.3-fpm \
	php-mysql \
	php-json \
	php-cli \
	php-zip \
	php-cgi \
	php-pear \
	php-mbstring \
	php-gd \
	php-imagick \
	wget \
	openssl \
	libnss3-tools \
	sudo \
	sendmail \
	curl \
	vim 

#Install phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz -O - | tar -xz
RUN mv phpMyAdmin-5.0.2-english /var/www/html/phpmyadmin
RUN mkdir /var/www/html/phpmyadmin/tmp
RUN chmod 755 /var/www/html/phpmyadmin/tmp

#Wordpress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp
RUN tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html

#Add files from srcs into container
COPY ./srcs/startup.sh .
COPY ./srcs/default /etc/nginx/sites-available/
COPY ./srcs/phpMyAdmin.conf /etc/nginx/conf.d/
COPY ./srcs/wp-config.php /var/www/html/
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin/
COPY ./srcs/php.ini /etc/php/7.3/fpm/
COPY ./srcs/nginx.conf /etc/nginx/

#Configure the database.
RUN service mysql start && \
	mysql -e "UPDATE mysql.user SET Password=PASSWORD('hello') WHERE User='root'" && \
	mysql -e "DELETE FROM mysql.user WHERE User=''" && \
	mysql -e "DELETE FROM mysql.user WHERE User-'root' AND Host NOT IN \
				('localhost', '127.0.0.1', '::1')" && \
	mysql -e "FLUSH PRIVILEGES"

#Make a new user for phpMyAdmin, and create mysql database.
RUN service mysql start && \
	mysql -e "CREATE USER 'rde-vrie'@'localhost' IDENTIFIED BY 'hello'" && \
	mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'rde-vrie'@'localhost' IDENTIFIED BY 'hello';" && \
	mysql -e "FLUSH PRIVILEGES" && \
	mysql -e "CREATE DATABASE phpmyadmin" && \
	mysql phpmyadmin < /var/www/html/phpmyadmin/sql/create_tables.sql && \
	mysql -e "CREATE DATABASE wordpress"

#Download certificate for SSL
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-arm
RUN chmod +x mkcert
RUN mv mkcert /usr/local/bin/
RUN /usr/local/bin/mkcert -install 
RUN /usr/local/bin/mkcert localhost

#Configure Wordpress
RUN chmod 755 /var/www/html/wp-config.php
RUN adduser --disabled-password -gecos "" rde-vrie && \
	sudo adduser rde-vrie sudo
RUN wget -O wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN chown rde-vrie -R /var/www
RUN service mysql start && \
	sudo -u rde-vrie -i -- wp core install --url=localhost --title="wordpress" --admin_name=rde-vrie --admin_password=hello --admin_email=rde-vrie@example.com --path=/var/www/html

#Set owner of folder to www-data
RUN chown -R www-data:www-data /var/www/
RUN rm -r /var/www/html/index.nginx-debian.html

#Open ports
EXPOSE 80
EXPOSE 443
EXPOSE 25

#Run commands
CMD bash startup.sh
