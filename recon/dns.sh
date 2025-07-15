#!/bin/bash

script_name="$(basename $0)"

if [ -z "$1" ]; then
	printf "Usage: $script_name domain_name [server]\n"
	exit 1
fi

domain_name="$1"

if [ -z "$2" ]; then
	server=1.1.1.1
else
	server="$2"
fi

WHOIS_OUT=$(timeout 3s whois tryhackme.com 2>/dev/null)

printf """
 WHOIS
===============================================================
"""
printf "%s" "$WHOIS_OUT" \
	| awk '!/For more information on Whois status codes/ { print } /For more information on Whois status codes/ { exit }'



printf """
 NSLOOKUP
===============================================================
"""
nslookup -type=A "$domain_name"
nslookup -type=MX "$domain_name" "$server"
nslookup -type=TXT "$domain_name"



printf """
 DIG 
===============================================================
"""
dig "$domain_name" A
dig @1.1.1.1 "$domain_name" MX
dig "$domain_name" TXT
