#!/bin/bash

[ -z $1 ] && echo "must provide target domain as arg1" && exit 1

deploy_subfinder(){
	
	#host=$(quik deploy 1gb 1 void-linux | awk '{ if($1=/^new/){print $4}}')
	#echo "Waiting for subfinder host to become ready..."
	#sleep 80
	#ssh -o "StrictHostKeyChecking no" void@$host 'sudo xbps-install -Sy rsync'
	cd subfinder
	#printf "SERVERS = void@$host\n" > config.mk
	sed -i "s/target=.*$/target=$1/" script && make || echo "something went wrong"
	cd -
}

prepare_for_masscan(){
	cd subfinder && cat results/subdomains_resolved.txt | docker run -i projectdiscovery/dnsprobe -silent | awk '{print $2}' | sort -u > ../masscan/files/for_masscan.txt
}

#deploy_subfinder $1

prepare_for_masscan
