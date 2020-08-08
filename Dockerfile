# getting base image
FROM debian:buster

MAINTAINER rde-vrie

# Update & install
RUN apt-get update && apt-get install -y \
	#apt-utils \
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

#CMD nginx -g 'daemon off;' 
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz -O - | tar -xz
RUN mv phpMyAdmin-5.0.2-english /var/www/html/phpmyadmin
RUN mkdir /var/www/html/phpmyadmin/tmp
RUN chmod 755 /var/www/html/phpmyadmin/tmp

#Wordpress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp
#RUN mkdir /var/www/html/wordpress
RUN tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html

#Add files from srcs into container
COPY ./srcs/startup.sh .
COPY ./srcs/index.html /var/www/html/
COPY ./srcs/containerfiles/default /etc/nginx/sites-available/
COPY ./srcs/phpMyAdmin.conf /etc/nginx/conf.d/
COPY ./srcs/containerfiles/wp-config.php /var/www/html/
COPY ./srcs/containerfiles/config.inc.php /var/www/html/phpmyadmin/
COPY ./srcs/containerfiles/php.ini /etc/php/7.3/fpm/
COPY ./srcs/containerfiles/nginx.conf /etc/nginx/

RUN chmod 755 /var/www/html/wp-config.php


# Configure the database.//dit stuk is compleet van mark
RUN service mysql start && \
	mysql -e "UPDATE mysql.user SET Password=PASSWORD('hello') WHERE User='root'" && \
	mysql -e "DELETE FROM mysql.user WHERE User=''" && \
	mysql -e "DELETE FROM mysql.user WHERE User-'root' AND Host NOT IN \
				('localhost', '127.0.0.1', '::1')" && \
	mysql -e "FLUSH PRIVILEGES"

# Make a new user for phpMyAdmin, and create the configuration storage tables.
RUN service mysql start && \
	mysql -e "CREATE USER 'rde-vrie'@'localhost' IDENTIFIED BY 'hello'" && \
	mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'rde-vrie'@'localhost' IDENTIFIED BY 'hello';" && \
	mysql -e "FLUSH PRIVILEGES" && \
	mysql -e "CREATE DATABASE phpmyadmin" && \
	mysql phpmyadmin < /var/www/html/phpmyadmin/sql/create_tables.sql && \
	mysql -e "CREATE DATABASE wordpress"

# download certificate for SSL
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-arm
RUN chmod +x mkcert
RUN mv mkcert /usr/local/bin/
RUN /usr/local/bin/mkcert -install 
RUN /usr/local/bin/mkcert localhost

# Configure Wordpress
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

CMD bash startup.sh
#RUN add-apt-repository ppa:phpmyadmin/ppa
#COPY static-html-directory /usr/share/nginx/html

#dit zorgt ervoor dat het opstart
#docker build -t <name> .
#docker run --rm --name rixt -p 80:80 <image id>

#ENV MYSQL_SERVER localhost
#ENV MYSQL_CLIENT localhost
#ENV MYSQL_USER root
#ENV MYSQl_PASS password
#ENV MYSQL_DB wordpress
#ENV APP_USER admin
#ENV APP_PASS password
#ENV WP_KEY "Hello World"




# docker build . : om image aan te maken
# docker build -t <naam> . : maak image en geef het een naam
# docker images : overzicht van gebouwde images

# docker run -p 80:80 <id van de image> : om container te bouwen (port 80)
# docker run --rm -it --name -p 80:80 -p 443:443 <id image>
# docker rmi <id van de image> : image verwijderen
# docker container ls -a : overzicht containers

# docker container rm <id> <id2> : containers met id en id2 verwijderen
# docker stop <container id> : stop a container


# 1. remove containers: docker rm $(docker ps -a -q)
# 2. remove images: docker rmi -f $(docker images -q)

############3#rondneuzen in mn container#################3

# docker exec -it <naam container> bash
# Nu zit je in de bash van je container, veel plezier! (je kunt geen vim gebruiken, dus gebruik cat als je een file wil zien
