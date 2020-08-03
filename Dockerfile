# getting base image
FROM debian:buster

MAINTAINER rde-vrie

RUN apt-get update

CMD ["echo", "Hello World!"]

#docker run nginx
#generate new image:

#FROM nginx : dit mag niet, je moet nginx downloaden alsof je het op een computer van debian buster download
# -y zorgt dat hij accepteert dat het ruimte inneemt
RUN apt-get install -y nginx
CMD nginx -g 'daemon off;' 
RUN apt-get install -y default-mysql-server
RUN apt-get install -y php
RUN apt-get install -y php-fpm
RUN apt-get install -y php-mysql
RUN apt-get install wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz -O - | tar -xz

#ADD ./srcs/nginx.conf /etc/nginx/
ADD ./srcs/startup.sh .
ADD ./srcs/index.html /var/www/html/

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
# docker build -t <naam> . : met naam
# docker images : overzicht van gebouwde images

# docker run -p 80:80 <id van de image> : om container te bouwen (port 80)
# docker rmi <id van de image> : image verwijderen
# docker container ls -a : overzicht containers

# docker container rm <id> <id2> : containers met id en id2 verwijderen
# docker stop <container id> : stop a container


# 1. remove containers: docker rm $(docker ps -a -q)
# 2. remove images: docker rmi -f $(docker images -q)

############3#rondneuzen in mn container#################3

# docker exec -it <naam container> bash
# Nu zit je in de bash van je container, veel plezier! (je kunt geen vim gebruiken, dus gebruik cat als je een file wil zien
