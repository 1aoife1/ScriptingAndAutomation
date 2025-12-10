#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){

    echo -n "Please Input an Instructor Full Name: "
    read instName

    echo ""
    echo "Courses of $instName :"
    cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
    sed 's/;/ | /g'
    echo ""
}

function courseCountofInsts(){

    echo ""
    echo "Course-Instructor Distribution"
    cat "$courseFile" | cut -d';' -f7 | \
    grep -v "/" | grep -v "\.\.\." | \
    sort -n | uniq -c | sort -n -r
    echo ""
}

# TODO - 1
# Display all the courses in a given location (classroom)
# Output: course code, course name, days, time, instructor
function displayCoursesOfLocation(){

    echo -n "Please Input a Class Name (e.g. JOYC 310): "
    read room

    echo ""
    echo "Courses in $room :"
    # room is assumed to be field 5, instructor is field 7
    cat "$courseFile" | grep "$room" | cut -d';' -f1,2,3,4,7 | \
    sed 's/;/ | /g'
    echo ""
}

# TODO - 2
# Display all courses that have availability (>0 seats) for a given subject code
function displayAvailableBySubject(){

    echo -n "Please Input a Subject Code (e.g. SEC, CSCI): "
    read subject

    echo ""
    echo "Available courses for subject: $subject"
    echo ""

    # adjust seatField to the column index that holds "available seats" in your slides
    seatField=10

    awk -F';' -v subj="$subject" -v seatField="$seatField" '
        # $1 = course code (e.g. SEC 260-01)
        # seatField = available seats column
        $1 ~ subj {
            seats = $seatField + 0
            if (seats > 0) {
                printf "%s | %s | %s | %s | %s | %s seats available\n",
                       $1, $2, $3, $4, $7, seats
            }
        }
    ' "$courseFile"
    echo ""
}

while :
do
    echo ""
    echo "Please select and option:"
    echo "[1] Display courses of an instructor"
    echo "[2] Display course count of instructors"
    echo "[3] Display courses of a classroom"
    echo "[4] Display available courses of subject"
    echo "[5] Exit"

    read userInput
    echo ""

    if [[ "$userInput" == "5" ]]; then
        echo "Goodbye"
        break

    elif [[ "$userInput" == "1" ]]; then
        displayCoursesofInst

    elif [[ "$userInput" == "2" ]]; then
        courseCountofInsts

    elif [[ "$userInput" == "3" ]]; then
        displayCoursesOfLocation

    elif [[ "$userInput" == "4" ]]; then
        displayAvailableBySubject

    # TODO - 3 Display a message, if an invalid input is given
    else
        echo "Invalid option, please try again."
    fi
done