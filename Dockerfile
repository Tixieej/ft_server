# getting base image
FROM debian:buster

MAINTAINER rde-vrie

# Update & install
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
	wget \
	openssl \
	libnss3-tools

#CMD nginx -g 'daemon off;' 
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz -O - | tar -xz
RUN mv phpMyAdmin-5.0.2-english /var/www/html/phpmyadmin
RUN mkdir /var/www/html/phpmyadmin/tmp
RUN chmod 755 /var/www/html/phpmyadmin/tmp

#Wordpress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp
RUN mkdir /var/www/html/wordpress
RUN tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/wordpress

#Add files from srcs into container
COPY ./srcs/startup.sh .
COPY ./srcs/index.html /var/www/html/
COPY ./srcs/containerfiles/default /etc/nginx/sites-available/
COPY ./srcs/phpMyAdmin.conf /etc/nginx/conf.d/
COPY ./srcs/containerfiles/wp-config.php /var/www/html/wordpress/
COPY ./srcs/containerfiles/config.inc.php /var/www/html/phpmyadmin/

#Set owner of folder to www-data
RUN chown -R www-data /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/phpmyadmin/tmp
RUN chown -R www-data /var/www/html/

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


#start mysql and make user:
#RUN service mysql start && \
#	mysql -u root && \
#	mysql -e "CREATE DATABASE phpmyadmin" && \
#	mysql -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass';" && \
#	#mysql -e "CREATE USER 'rixt'@'localhost' IDENTIFIED BY 'hello';" && \
#	mysql phpmyadmin < /usr/share/phpMyAdmin/sql/create_tables.sql && \
	#mysql -u root -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'rixt'@'localhost' IDENTIFIED BY 'hello';" && \
	#mysql -u root -e "FLUSH PRIVILEGES;"


# download fake certificate for SSL
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-arm
#RUN mv mkcert-v1.4.1-linux-arm mkcert
RUN chmod +x mkcert
RUN mv mkcert /usr/local/bin/
RUN /usr/local/bin/mkcert -install 
RUN /usr/local/bin/mkcert localhost
#RUN mv localhost.pem /root/
#RUN mv localhost-key.pem /root/


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

# grab the latest wordpress, install it and remove the zip file
#RUN wget -P /var/www/html/ https://wordpress.org/latest.zip && \
#unzip /var/www/html/latest.zip -d /var/www/html/ && \
#rm -rf /var/www/html/latest.zip


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
