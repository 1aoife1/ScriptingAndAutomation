#! /bin/bash

{

 echo "<html>"
 echo "<body>"
 echo "<h3>Access.log with Indicators of compromise:</h3>"
 echo "<table border=\"1\">"
 while read -r ip datetime url; do
  echo "<tr><td>$ip</td><td>$datetime</td><td>$url</td></tr>"
 done < report.txt
 echo "<table>"
 echo "<body>"
 echo "</html>"

} > report.html

sudo mv report.html /var/www/html/