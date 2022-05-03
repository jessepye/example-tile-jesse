#!/bin/bash

while :
do
  sleep 5
	echo $(date): Example Tile Working... > /var/vcap/sys/log/example/example.log
done
