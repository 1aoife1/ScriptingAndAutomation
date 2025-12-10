#!/bin/bash

link="http://10.0.17.47/Assignment.html"

page=$(curl -sL "$link")

temps=$(echo "$page" \
  | xmlstarlet fo --html --recover --dropdtd 2>/dev/null \
  | xmlstarlet sel -t \
      -m "//table[@id='temp']/tr[position()>1]" \
      -v "concat(normalize-space(td[1]), ' ', normalize-space(td[2]))" -n 2>/dev/null \
  | tr -d '\r' \
  | sed '/^[[:space:]]*$/d')

pressures=$(echo "$page" \
  | xmlstarlet fo --html --recover --dropdtd 2>/dev/null \
  | xmlstarlet sel -t \
      -m "//table[@id='press']/tr[position()>1]" \
      -v "concat(normalize-space(td[1]), ' ', normalize-space(td[2]))" -n 2>/dev/null \
  | tr -d '\r' \
  | sed '/^[[:space:]]*$/d')

mapfile -t temp_array  < <(echo "$temps")
mapfile -t press_array < <(echo "$pressures")

rows=${#temp_array[@]}

for ((i=0; i<rows; i++)); do
    temp_line="${temp_array[$i]}"
    press_line="${press_array[$i]}"

    temp_val="${temp_line%% *}"
    datetime="${temp_line#* }"
    press_val="${press_line%% *}"

    printf "%s %s %s\n" "$press_val" "$temp_val" "$datetime"
done