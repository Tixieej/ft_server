#!/bin/bash

#COLORS
GREEN="\033[92m"
DEFAULT="\033[39m"

service php7.3-fpm start
service mysql start
service sendmail start
echo -e "${GREEN}done${DEFAULT}"
nginx -g 'daemon off;'
