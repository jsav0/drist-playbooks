#!/bin/sh
printf "\nExecuting deploy masscan script...\n"
#cat results.txt | docker run -i projectdiscovery/dnsprobe -silent | awk '{print $2}' | sort -u > for_masscan.txt

deploy_fleet(){
        quik deploy 1gb 3 void-linux
}
 
#fleet=$(quik deploy 1gb 3 void-linux | awk '{ if($1=/^new/){print $4}}')

prepare_masscan(){
        fleet=$(quik ls | awk '{ if($1=/^new/){print $4}}')
        numOfServers=$(echo $fleet | wc -w)
        sleep 60
        for i in $fleet
        do
		#ssh -o "StrictHostKeyChecking no" void@$i 'sudo xbps-install -Sy rsync'
                
		dir=scanner-$i
		mkdir -p $dir/files
		printf "SERVERS = void@$i\n" > $dir/config.mk
		cp for_masscan.txt $dir/files/for_masscan.txt
		
		for n in $(seq 1 ${numOfServers})
		do
			printf "#!/bin/sh\n" >> $dir/script
			printf "cp -f /home/void/.drist_files_*/for_masscan.txt /tmp/for_masscan.txt\n" >> $dir/script
			echo "masscan -iL /tmp/for_masscan.txt -p0-65535 --exclude-port p80,8000,8008,8800,8080,8880,8888,443,4433,8443 --shard $n/$numOfServers" >> $dir/script
		done


        done
#	echo $dir
	exit 5
	
	numOfServers=$(find . -type d -name 'scanner-*' | wc -l)
	for i in $(seq 1 ${numOfServers})
	do
		printf "#!/bin/sh\n" >> $dir/script
		printf "cp -f /home/void/.drist_files_*/for_masscan.txt /tmp/for_masscan.txt\n" >> $dir/script
		echo "masscan -iL /tmp/for_masscan.txt -p0-65535 --exclude-port p80,8000,8008,8800,8080,8880,8888,443,4433,8443 --shard $i/$numOfServers" >> script-$i
	done
	exit 5


}


deploy_masscan(){

        fleet=$(quik ls | awk '{ if($1=/^new/){print $4}}')
        SERVERS=$(quik ls | awk '{ if($1=/^new/){print $4}}' | wc -l)
	for i in $(seq 1 ${SERVERS})
	do
		dir=scanner-$i
		mkdir -p $dir/files
		cp for_masscan.txt $dir/files/for_masscan.txt
		
		[ ! -s $dir/script ] && {
			printf "#!/bin/sh\n" >> $dir/script
			printf "cp -f /home/void/.drist_files_*/for_masscan.txt /tmp/for_masscan.txt\n" >> $dir/script
			echo "masscan -iL /tmp/for_masscan.txt -p0-65535 --exclude-port p80,8000,8008,8800,8080,8880,8888,443,4433,8443 --shard $i/3" >> $dir/script
		}
		
	done
}

prepare_masscan
