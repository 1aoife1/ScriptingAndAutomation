#!/bin/bash

logFile="fileaccesslog.txt"
now=$(date)

echo "File was accessed $now" >> fileaccesslog.txt

echo "To:henzly.daggy@mymail.champlain.edu" > email.txt
echo "Subject: Access" >> email.txt
cat fileaccesslog.txt >> email.txt
cat email.txt | ssmtp henzly.daggy@mymail.champlain.edu
