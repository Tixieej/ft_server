#!/bin/bash

#COLORS
RED="\033[91m"
YELLOW="\033[33m"
BLUE="\033[94m"
GREEN="\033[92m"
DEFAULT="\033[39m"
LIME="\033[38;5;154m"
PURPLE="\033[38;5;183m"

echo -e "${LIME}Hello, world!${DEFAULT}"
echo -e "${PURPLE}Hello, Rixt.${GREEN}"
ls /etc/nginx/
echo -e "${RED}"

# Generate keys for SSL certificate
#cd /etc/ssl/certs/
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt 
#
#service mysql start
#mysql < /usr/share/phpMyAdmin/sql/create_tables.sql -u root -p
#mysql -u root -p
#mysql -u root -p -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass';"
#mysql -u root -p -e "FLUSH PRIVILEGES;"
nginx -g 'daemon off;'


# create endless loop for container: tail -f /dev/null






#cd ..; ./a.out 

