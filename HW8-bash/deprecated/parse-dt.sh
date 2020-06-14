#!/usr/bin/env bash
##
# Get data lines for defined period
##
# Convert datetime from access.log format to parseable by 'date --date' argument
logdt2dt() {
    echo "$1" | tr "/" ":" | tr " " ":" | awk -F":" '{ print $1" "$2" "$3" "$4":"$5":"$6" "$7 ; }'
}

# Convert datetime from access.log format to unix timestamp
logdt2ts() {
    logdt2dt "$1" | xargs -I{} date --date="{}" +"%s"
}

NOW="14/Aug/2019:05:12:10 +0300"
FROM=$(logdt2dt "$NOW" | xargs -I{} date --date="{} -1 hour" +"%s")
TO=$(logdt2ts "$NOW")
