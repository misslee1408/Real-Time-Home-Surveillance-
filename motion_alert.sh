#!/bin/bash

# Twilio credentials from environment variables
ACCOUNT_SID=${ACCOUNT_SID}
AUTH_TOKEN=${AUTH_TOKEN}
TWILIO_PHONE_NUMBER=${TWILIO_PHONE_NUMBER}
USER_PHONE_NUMBER=${USER_PHONE_NUMBER}

# GPIO pin connected to PIR sensor
PIR_GPIO=17

# Function to send SMS using Twilio
send_alert() {
    MESSAGE="Motion detected!"
    curl 'https://api.twilio.com/2010-04-01/Accounts/'"$ACCOUNT_SID"'/Messages.json' -X POST \
    --data-urlencode 'From='"$TWILIO_PHONE_NUMBER" \
    --data-urlencode 'To='"$USER_PHONE_NUMBER" \
    --data-urlencode 'Body='"$MESSAGE" \
    -u "$ACCOUNT_SID:$AUTH_TOKEN"
}

# Function to check if livestream is active
is_livestreaming() {
    STREAM_URL="http://localhost:8888" 
    curl --silent --head $STREAM_URL | grep "200 OK" > /dev/null
    return $?
}

# Configure GPIO pin as input
gpio -g mode $PIR_GPIO in

echo "Monitoring for motion..."

# Monitor PIR sensor
while true; do
    if [ $(gpio -g read $PIR_GPIO) -eq 1 ]; then
        if is_livestreaming; then
            echo "Motion detected during livestream!"
            send_alert
            sleep 60  # Delay to avoid multiple alerts for a single motion event
        else
            echo "Motion detected, but no livestream active."
        fi
    fi
    sleep 1
done
