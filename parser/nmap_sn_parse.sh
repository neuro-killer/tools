#!/bin/bash

# Usage: ./nmap_file_parser.sh <nmap_output_file>

parser_name="$(basename "$0")"

if [ -z "$1" ]; then
  printf "Usage: %s <nmap_output_file>" "$parser_name"
  exit 1
fi

file=$1

awk '
  /^Nmap scan report/ { ip = $5 }
  /MAC Address:/ {
    mac = $3
    sub(/^MAC Address: [^ ]+ /, "", $0)
    vendor = $0
  }
  /^Host is up/ {
    if (mac) {
      print ip, mac, vendor
    } else {
      print ip, "No MAC"
    }
    mac = ""; vendor = ""
  }
' "$file"

