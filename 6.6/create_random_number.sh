#!/bin/bash
#

DIR=/opt/nginx/html/app/proxy
FILE=proxy.html

while true;do
	echo "Application Server,This time create number: $RANDOM" > $DIR/$FILE
	sleep 1
done
