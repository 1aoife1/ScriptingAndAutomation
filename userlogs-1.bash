#! /bin/bash

authfile="/var/log/auth.log"

# CHANGE THIS to your own email address:
mailTo="henzly_daggy@my.mail.champlain.edu"

function getLogins(){
    logline=$(grep "systemd-logind" "$authfile" | grep "New session")
    dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,11 | tr -d '\.')
    echo "$dateAndUser"
}

# function: getFailedLogins
# Finds failed SSH password attempts and prints date/time, user, and IP.
function getFailedLogins(){
    grep "Failed password" "$authfile" | \
    awk '
        /Failed password/ {
            # Handles both:
            #  Failed password for USER from IP ...
            #  Failed password for invalid user USER from IP ...
            if ($9 == "invalid") {
                user=$10
                ip=$12
            } else {
                user=$9
                ip=$11
            }
            print $1, $2, $3, user, ip
        }
    '
}

# Send successful logins 
echo "To: $mailTo" > email_logins.txt
echo "Subject: Logins" >> email_logins.txt
echo "" >> email_logins.txt
getLogins >> email_logins.txt
cat email_logins.txt | ssmtp "$mailTo"

# Todo-2: Send failed logins as email
echo "To: $mailTo" > email_failed.txt
echo "Subject: Failed Logins" >> email_failed.txt
echo "" >> email_failed.txt
getFailedLogins >> email_failed.txt
cat email_failed.txt | ssmtp "$mailTo"