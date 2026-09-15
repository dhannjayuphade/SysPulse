#!/bin/bash

# SysPulse Hacker Style Theme Colors
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RESET='\033[0m'

clear
echo -e "${GREEN}================================================================${RESET}"
echo -e "${CYAN}   ███████╗██╗   ██╗███████╗██████╗ ██╗   ██╗██╗     ███████╗   ${RESET}"
echo -e "${CYAN}   ██╔════╝╚██╗ ██╔╝██╔════╝██╔══██╗██║   ██║██║     ██╔════╝   ${RESET}"
echo -e "${CYAN}   ███████╗ ╚████╔╝ ███████╗██████╔╝██║   ██║██║     █████╗     ${RESET}"
echo -e "${CYAN}   ╚════██║  ╚██╔╝  ╚════██║██╔═══╝ ██║   ██║██║     ██╔══╝     ${RESET}"
echo -e "${CYAN}   ███████║   ██║   ███████║██║     ╚██████╔╝███████╗███████╗   ${RESET}"
echo -e "${CYAN}   ╚══════╝   ╚═╝   ╚══════╝╚═╝      ╚═════╝ ╚══════╝╚══════╝   ${RESET}"
echo -e "${GREEN}================================================================${RESET}"
echo -e "${WHITE}  TOOL NAME : SysPulse - Cyber Reconnaissance Tool              ${RESET}"
echo -e "${WHITE}  CREATOR   : Dhananjay Uphade                                   ${RESET}"
echo -e "${GREEN}================================================================${RESET}\n"

# User Input
read -p "[+] ENTER TARGET WEBSITE URL OR IP: " TARGET

if [ -z "$TARGET" ]; then
    echo -e "${RED}[!] Error: Target URL or IP cannot be empty!${RESET}"
    exit 1
fi

# Clean URL for Recon
CLEAN_DOMAIN=$(echo "$TARGET" | awk -F/ '{print $3}')
if [ -z "$CLEAN_DOMAIN" ]; then
    CLEAN_DOMAIN=$TARGET
fi

echo -e "\n${YELLOW}[*] INITIATING RECONNAISSANCE ON: $CLEAN_DOMAIN ...${RESET}"
sleep 1.5

echo -e "\n${GREEN}[1] IP & HOSTING INFORMATION${RESET}"
echo -e "${CYAN}------------------------------------------------------------${RESET}"
IP_ADDR=$(dig +short $CLEAN_DOMAIN | tail -n1)
echo -e " ${WHITE}● Target IP     :${RESET} ${YELLOW}${IP_ADDR:-'Not Found'}${RESET}"
HOSTING_INFO=$(whois $IP_ADDR 2>/dev/null | grep -iE 'orgname|netname|descr' | head -n 1 | awk -F: '{print $2}')
echo -e " ${WHITE}● Hosting/Org   :${RESET}${GREEN}${HOSTING_INFO:-' Cloudflare/Protected'}${RESET}"

echo -e "\n${GREEN}[2] WHOIS & OWNER DETAILS${RESET}"
echo -e "${CYAN}------------------------------------------------------------${RESET}"
OWNER_NAME=$(whois $CLEAN_DOMAIN 2>/dev/null | grep -i 'Registrant Name' | head -n 1 | awk -F: '{print $2}')
OWNER_EMAIL=$(whois $CLEAN_DOMAIN 2>/dev/null | grep -i 'Registrant Email' | head -n 1 | awk -F: '{print $2}')
OWNER_PHONE=$(whois $CLEAN_DOMAIN 2>/dev/null | grep -i 'Registrant Phone' | head -n 1 | awk -F: '{print $2}')

echo -e " ${WHITE}● Owner Name    :${RESET}${YELLOW}${OWNER_NAME:-' Privacy Protected / Redacted'}${RESET}"
echo -e " ${WHITE}● Owner Email   :${RESET}${YELLOW}${OWNER_EMAIL:-' Privacy Protected'}${RESET}"
echo -e " ${WHITE}● Phone Number  :${RESET}${YELLOW}${OWNER_PHONE:-' Privacy Protected'}${RESET}"

echo -e "\n${GREEN}[3] DOMAIN TIMELINE (CREATED / UPDATED)${RESET}"
echo -e "${CYAN}------------------------------------------------------------${RESET}"
CREATED_DATE=$(whois $CLEAN_DOMAIN 2>/dev/null | grep -iE 'creation date|created' | head -n 1 | awk -F: '{print $2}')
UPDATED_DATE=$(whois $CLEAN_DOMAIN 2>/dev/null | grep -iE 'updated date|updated' | head -n 1 | awk -F: '{print $2}')

echo -e " ${WHITE}● Created Date  :${RESET}${GREEN}${CREATED_DATE:-' Unknown'}${RESET}"
echo -e " ${WHITE}● Updated Date  :${RESET}${GREEN}${UPDATED_DATE:-' Unknown'}${RESET}"

echo -e "\n${GREEN}[4] TRAFFIC & ADMIN PAGE SCANNER${RESET}"
echo -e "${CYAN}------------------------------------------------------------${RESET}"
echo -e " ${WHITE}● Traffic Stats :${RESET} ${YELLOW}https://www.similarweb.com/website/$CLEAN_DOMAIN/${RESET}"
echo -e " ${WHITE}● Checking Admin Pages:${RESET}"

# Simple Admin Page Finder
ADMIN_PATHS=("admin" "admin/login" "wp-admin" "login" "cpanel")
for path in "${ADMIN_PATHS[@]}"; do
    HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" "http://$CLEAN_DOMAIN/$path")
    if [ "$HTTP_CODE" -eq 200 ] || [ "$HTTP_CODE" -eq 301 ] || [ "$HTTP_CODE" -eq 302 ]; then
        echo -e "   ${GREEN}[FOUND]${RESET} http://$CLEAN_DOMAIN/$path (Status: $HTTP_CODE)"
    fi
done

echo -e "\n${GREEN}================================================================${RESET}"
echo -e "${CYAN}             RECONNAISSANCE COMPLETE - SysPulse                 ${RESET}"
echo -e "${GREEN}================================================================${RESET}\n"
