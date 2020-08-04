# getting base image
FROM debian:buster

MAINTAINER rde-vrie

# Update & install
RUN apt-get update && apt-get install -y \
	nginx \
	default-mysql-server \
	php \
	php-fpm \
	php-mysql \
	php-json \
	php-mbstring \
	wget \
	openssl \
	libnss3-tools

#CMD nginx -g 'daemon off;' 
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz -O - | tar -xz
RUN mv phpMyAdmin-5.0.2-english /usr/share/phpMyAdmin
#RUN apt-get install -y openssl

#ADD ./srcs/nginx.conf /etc/nginx/

#Add files from srcs into container
ADD ./srcs/startup.sh .
ADD ./srcs/index.html /var/www/html/
ADD ./srcs/containerfiles/default /etc/nginx/sites-enabled/
ADD ./srcs/phpMyAdmin.conf /etc/nginx/conf.d/
ADD ./srcs/containerfiles/config.inc.php /usr/share/phpMyAdmin/

# download fake certificate for SSL
#RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-armi
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
#docker build .
#docker run --name rixt -p 80:80 <image id>

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
# docker run -p 80:80 -p 443:443 <id image>
# docker rmi <id van de image> : image verwijderen
# docker container ls -a : overzicht containers

# docker container rm <id> <id2> : containers met id en id2 verwijderen
# docker stop <container id> : stop a container


# 1. remove containers: docker rm $(docker ps -a -q)
# 2. remove images: docker rmi -f $(docker images -q)

############3#rondneuzen in mn container#################3

# docker exec -it <naam container> bash
# Nu zit je in de bash van je container, veel plezier! (je kunt geen vim gebruiken, dus gebruik cat als je een file wil zien
