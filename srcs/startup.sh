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

nginx -g 'daemon off;'


# create endless loop for container: tail -f /dev/null






#cd ..; ./a.out 

