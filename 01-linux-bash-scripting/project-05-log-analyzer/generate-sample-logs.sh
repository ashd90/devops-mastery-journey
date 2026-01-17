#!/bin/bash

# Generate sample Apache/Nginx access logs
LOG_FILE="sample-access.log"

IPS=("192.168.1.100" "10.0.0.50" "172.16.0.20" "203.0.113.10" "198.51.100.5")
URLS=("/index.html" "/about.html" "/contact.html" "/api/users" "/api/products" "/images/logo.png" "/css/style.css")
STATUS_CODES=(200 200 200 200 301 404 500 502)
USER_AGENTS=("Mozilla/5.0" "Chrome/91.0" "Safari/14.0")

> "$LOG_FILE"

for i in {1..1000}; do
    IP=${IPS[$RANDOM % ${#IPS[@]}]}
    URL=${URLS[$RANDOM % ${#URLS[@]}]}
    STATUS=${STATUS_CODES[$RANDOM % ${#STATUS_CODES[@]}]}
    SIZE=$((RANDOM % 10000 + 100))
    UA=${USER_AGENTS[$RANDOM % ${#USER_AGENTS[@]}]}
    
    echo "$IP - - [$(date '+%d/%b/%Y:%H:%M:%S %z')] \"GET $URL HTTP/1.1\" $STATUS $SIZE \"-\" \"$UA\"" >> "$LOG_FILE"
done

echo "Generated $LOG_FILE with 1000 entries"
