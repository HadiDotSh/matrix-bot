#!/bin/bash
# Matrix-Bot
# By @HadiDotSh

roomID=""
token=""
server=""

# Path to the hook.sh file 
hook=""

# A file where the last event ID will be stored :
last_event="$HOME/.last_event.txt"
[[ -f $last_event ]] || touch $last_event

# check for new messages.
function newEvent(){
    lastChunk=$( curl -sXGET "https://${server}/_matrix/client/r0/rooms/${roomID}/messages?access_token=${token}&limit=1&from=END&dir=b" | sed 's/,/\n/g' ) &&\
    eventID=$( echo "${lastChunk}" | grep '^"event_id":"' | sed 's/"event_id":"//;s/"//g' ) && lastEventID=$(cat $last_event)
    [[ "${eventID}" != "${lastEventID}" ]] || exit && echo "$eventID" > $last_event
    echo "${lastChunk}" | grep '^"body":"' | sed 's/"body":"//;s/"}//g'
}

# send {message}
function send(){
    eventID=$(curl -s -XPOST -d '{"msgtype":"m.text", "body":"'"${*}"'"}' "https://${server}/_matrix/client/r0/rooms/${roomID}/send/m.room.message?access_token=${token}")
    echo "$( echo $eventID | sed 's/{"event_id":"//;s/"}//g')" > $last_event
}

message=$(newEvent)
[[ -z "${message}" ]] && exit
source $hook
