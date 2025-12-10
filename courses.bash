#! /bin/bash

# This is the link we will scrape
link="http://10.0.17.47/Courses.html"   

curl -sL "$link" \
  | xmlstarlet fo --html --recover --dropdtd 2>/dev/null \
  | xmlstarlet sel --template --copy-of "//table//tr" 2>/dev/null \
  | sed 's/<\/tr>/\n/g' \
  | sed -e 's/&amp;//g' \
        -e 's/<tr>//g' \
        -e 's/<td[^>]*>//g' \
        -e 's/<\/td>/;/g' \
        -e 's/<[/\]\{0,1\}a[^>]*>//g' \
        -e 's/<[/\]\{0,1\}nobr>//g' \
  > courses.txt