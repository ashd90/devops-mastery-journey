#!/bin/bash

##############################################
# Log Analyzer Script
# Analyzes Apache/Nginx access logs
# Author: Your Name
# Date: January 2026
##############################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored headers
print_header() {
    echo -e "${BLUE}==================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}==================================${NC}"
}

# Function to check if log file exists
check_log_file() {
    if [ ! -f "$1" ]; then
        echo -e "${RED}Error: Log file '$1' not found!${NC}"
        exit 1
    fi
}

# Function to analyze top IPs
analyze_top_ips() {
    print_header "Top 10 IP Addresses"
    awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10 | \
    while read count ip; do
        echo -e "${YELLOW}$ip${NC} - ${GREEN}$count requests${NC}"
    done
}

# Function to analyze top URLs
analyze_top_urls() {
    print_header "Top 10 Requested URLs"
    awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10 | \
    while read count url; do
        echo -e "${YELLOW}$url${NC} - ${GREEN}$count requests${NC}"
    done
}

# Function to analyze HTTP status codes
analyze_status_codes() {
    print_header "HTTP Status Code Distribution"
    awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn | \
    while read count code; do
        case $code in
            200|201|204) color=$GREEN ;;
            301|302) color=$YELLOW ;;
            400|401|403|404) color=$RED ;;
            500|502|503) color=$RED ;;
            *) color=$NC ;;
        esac
        echo -e "${color}$code${NC} - $count occurrences"
    done
}

# Main execution
main() {
    # Check if log file argument is provided
    if [ $# -eq 0 ]; then
        echo -e "${RED}Usage: $0 <log-file-path>${NC}"
        echo "Example: $0 /var/log/nginx/access.log"
        exit 1
    fi

    LOG_FILE="$1"
    check_log_file "$LOG_FILE"

    echo -e "${GREEN}Analyzing log file: $LOG_FILE${NC}\n"

    # Run analysis
    analyze_top_ips
    echo
    analyze_top_urls
    echo
    analyze_status_codes

    # Summary
    print_header "Summary"
    TOTAL_REQUESTS=$(wc -l < "$LOG_FILE")
    UNIQUE_IPS=$(awk '{print $1}' "$LOG_FILE" | sort -u | wc -l)
    echo -e "Total Requests: ${GREEN}$TOTAL_REQUESTS${NC}"
    echo -e "Unique IPs: ${GREEN}$UNIQUE_IPS${NC}"
}

# Run main function
main "$@"
