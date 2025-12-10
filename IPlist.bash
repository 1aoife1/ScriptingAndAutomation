#!/bin/bash

[ $# -ne 1 ] && echo "Usage: IPList.bash <Prefix>" && exit 1

prefix=$1

[ ${#prefix} -lt 5 ] && \
printf "Prefix length is too short\nPrefix example: 10.0.17\n" && \
exit 1


for i in {1..254}
do
	ip="$prefix.$i"
	ping -W 0.2 -c 1 $ip | grep "bytes from" | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}"
done
