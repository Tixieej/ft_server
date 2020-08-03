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
cat /etc/nginx/nginx.conf
nginx -g 'daemon off;'







#cd ..; ./a.out 

