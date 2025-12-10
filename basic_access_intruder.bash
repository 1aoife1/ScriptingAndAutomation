#!/bin/bash

ip="10.0.17.46"

for i in {1..20}
do
	curl $ip
done