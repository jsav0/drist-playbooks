#!/bin/bash

[ -z $1 ] && exit 1
target="$1"

[ -f resolvers.txt ] || {
        docker run --init -v $(pwd):/dnsvalidator/output -it wfnintr/dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 20 -o /dnsvalidator/output/resolvers.txt
}

printf "\nenumerating %s...\n" "$target"
subfinder -silent -rL resolvers.txt -d $target | shuffledns -r resolvers.txt -d $target -silent -o subdomains-alive.txt


cat subdomains-alive.txt | docker run -i projectdiscovery/dnsprobe --silent -r A | awk '{print $2}' > for_masscan.txt

#printf "\nscanning for common webservers\n"
#sudo masscan -iL for_masscan.txt -Pn -p 80,8000,8008,8800,8080,8880,8888,443,4433 --rate 700 --banner > masscan_webservers_common.txt

printf "\nscanning for ftp ports\n"
sudo masscan -iL for_masscan.txt -Pn -p21 --rate 700 | awk '{print $NF}' > masscan_ftpservers.txt
[ -s masscan_ftpservers.txt ] && nmap -Pn -sV -sC -p21 -iL masscan_ftpservers.txt > nmap_ftpservers.txt

printf "\nscanning for ssh ports\n"
sudo masscan -iL for_masscan.txt -Pn -p22 --rate 700 | awk '{print $NF}' > masscan_sshservers.txt
[ -s masscan_sshservers.txt ] && nmap -Pn -sV -sC -p22 -iL masscan_sshservers.txt > nmap_sshservers.txt
