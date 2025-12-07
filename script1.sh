#!/bin/bash


curl -s http://10.0.17.47/IOC.html | sed -n '/<table>/,/<\/table>/p' | grep -o '<td>[^<]*</td>' | sed -n '1~2s/<td>\([^<]*\)<\/td>/\1/p' > IOC.txt