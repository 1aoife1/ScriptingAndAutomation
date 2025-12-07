#!/bin/bash


grep -F -f IOC.txt access.log | awk '{ gsub(/\[/,"",$4); print $1, $4, $7 }' > report.txt