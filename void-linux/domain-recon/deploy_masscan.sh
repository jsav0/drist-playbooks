#!/bin/sh
SERVERS=10
awk '{print $2}' subfinder/results/all_hosts.txt > all_hosts.txt

printf "\nExecuting deploy masscan script...\n"

deploy_fleet(){
        quik deploy 2gb $SERVERS void-linux
}
 
prepare_fleet(){
        fleet=$(quik ls | awk '{ if($1=/^new/){print $4}}')
        sleep 70
        for s in $fleet
        do
		ssh -o "StrictHostKeyChecking no" void@$s 'sudo xbps-install -Sy rsync masscan'
	done
	for i in $(seq 1 ${SERVERS})
	do
		dir=masscan/scanner-$i
		echo "building $dir" 
		mkdir -p $dir/files
		cp all_hosts.txt $dir/files/all_hosts.txt
		echo "#!/bin/sh" >> $dir/script
		echo "mkdir results" >> $dir/script
		echo "sudo masscan -iL all_hosts.txt -p0-65535 --exclude-port 80,8000,8008,8800,8080,8880,8888,443,4433,8443 --shard $i/$SERVERS > results/masscan_$i.txt" >> $dir/script
		chown -R void:void results
	done
	count=1
	for s in $fleet
	do
		printf "SERVERS = void@$s\n" > masscan/scanner-$count/config.mk
		count=$((count+1))
	done


}

deploy_masscan(){
	for d in masscan/scanner-*
	do
		cd $d
		ln -s ../../../../makefile
		echo "starting $d" 
		make &
		cd -
	done
}

results(){
	find . -name 'masscan_*.txt' -exec cat {} \; > masscan_all.txt
}
#prepare_masscan
deploy_fleet
prepare_fleet
deploy_masscan
