#! /bin/bash

logFile="/var/log/apache2/access.log.1"

function displayAllLogs(){
    cat "$logFile"
}

function displayOnlyIPs(){
    cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

# function: displayOnlyPages:
# like displayOnlyIPs - but only pages
function displayOnlyPages(){
    cat "$logFile" | cut -d ' ' -f 7 | sort | uniq
}

function histogram(){

    local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                                  | uniq)
    # This is for debugging, print here to see what it does to continue:
    # echo "$visitsPerDay"

    :> newtemp.txt  # what :> does is in slides
    echo "$visitsPerDay" | while read -r line;
    do
        local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                             | cut -d ":" -f 1)
        local IP=$(echo "$line" | cut -d  " " -f 1)

        local newLine="$IP $withoutHours"
        echo "$IP $withoutHours" >> newtemp.txt
    done
    cat "newtemp.txt" | sort -n | uniq -c
}

# function: frequentVisitors:
# Only display the IPs that have more than 10 visits
function frequentVisitors(){
    histogram | while read -r count ip date
    do
        if [ "$count" -gt 10 ]; then
            echo "$count $ip $date"
        fi
    done
}

# function: suspiciousVisitors
# Manually make a list of indicators of attack (ioc.txt)
# filter the records with these indicators
# only display the unique count of IP addresses.
function suspiciousVisitors(){
    local iocFile="ioc.txt"

    if [ ! -f "$iocFile" ]; then
        echo "IOC file '$iocFile' not found. Please create it first."
        return
    fi

    grep -F -f "$iocFile" "$logFile" \
        | cut -d ' ' -f 1 \
        | sort -n \
        | uniq -c
}

# Keep in mind that I have selected long way of doing things to
# demonstrate loops, functions, etc. If you can do things simpler,
# it is welcomed.

while :
do
    echo "PLease select an option:"
    echo "[1] Display all Logs"
    echo "[2] Display only IPS"
    echo "[3] Display only pages visited"
    echo "[4] Histogram"
    echo "[5] Frequent visitors"
    echo "[6] Suspicious visitors"
    echo "[7] Quit"

    read userInput
    echo ""

    if [[ "$userInput" == "7" ]]; then
        echo "Goodbye"
        break

    elif [[ "$userInput" == "1" ]]; then
        echo "Displaying all logs:"
        displayAllLogs

    elif [[ "$userInput" == "2" ]]; then
        echo "Displaying only IPS:"
        displayOnlyIPs

    elif [[ "$userInput" == "3" ]]; then
        echo "Displaying only pages:"
        displayOnlyPages

    elif [[ "$userInput" == "4" ]]; then
        echo "Histogram:"
        histogram

    elif [[ "$userInput" == "5" ]]; then
        echo "Frequent visitors:"
        frequentVisitors

    elif [[ "$userInput" == "6" ]]; then
        echo "Suspicious visitors:"
        suspiciousVisitors

    else
        echo "Invalid option, please try again."
    fi
done