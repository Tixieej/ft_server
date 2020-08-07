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

service php7.3-fpm start
service mysql start



nginx -g 'daemon off;'


# create endless loop for container: tail -f /dev/null






#cd ..; ./a.out 

