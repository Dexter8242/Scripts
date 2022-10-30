#!/bin/bash
#
# Recon tool:
# - See whois
# - Find subdomains
# - See if subdomains are alive
# - Screenshot alive subdomains
#
domain=$1
# Colors text red or resets it back to normal
RED="\033[1;31m"
RESET="\033[0m"

info_path=$domain/info
subdomain_path=$domain/subdomains
screenshot_path=$domain/screenshots

# If directory doesn't exist, create it
if [ ! -d "$domain" ]; then
	mkdir $domain
fi
if [ ! -d "$info_path" ]; then
	mkdir $info_path
fi
if [ ! -d "$subdomain_path" ]; then
	mkdir $subdomain_path
fi
if [ ! -d "$screenshot_path" ]; then
	mkdir $screenshot_path
fi

# Run tools
echo -e "${RED} [+] Checking whois information...${RESET}"
whois $1 > $info_path/whois.txt

echo -e "${RED} [+] Launching subfinder...${RESET}"
subfinder -d $domain > $subdomain_path/found.txt

echo -e "${RED} [+] Running assetfinder...${RESET}"
assetfinder $domain | grep $domain >> $subdomain_path/found.txt

echo -e "${RED} [+] Running amass (this process is slow)...${RESET}"
amass enum -d $domain

# Echo the found subdomains, filter to only include the specified domain, sort it by unique incase there's duplicates, then find alive domains, grep out the HTTPs to filter out HTTP, then remove the https:// part from the domain..
echo -e "${RED} [+] Checking for alive subdomains...${RESET}"
cat $subdomain_path/found.txt | grep $domain | sort -u | httprobe -prefer-https | grep https | sed 's/https\?:\/\///' | tee -a $subdomain_path/alive.txt

echo -e "${RED} [+] Taking screenshots...${RESET}"
gowitness file -f $subdomain_path/alive.txt -P $screenshot_path --no-http 
