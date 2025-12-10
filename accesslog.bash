#!/bin/bash

file="/var/log/apache2/access.log"

results=$(cat "$file" | grep page2.html | cut -d' ' -f1,7 | tr -d '"/')

echo "$results"

pageCount() {
	cat "$file" \
	| awk '{print $7}' \
	| sort \
	| uniq -c
}

countingCurlAccess() {
	cat "$file" \
	| grep curl \
	| awk '{print $1, $12}' \
	| sort \
	| uniq -c
}

countingCurlAccess

