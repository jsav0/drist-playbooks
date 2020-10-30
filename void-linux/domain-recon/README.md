## Recon Playbooks

These playbooks use [drist](), a wrapper around ssh+rsync, to automate the the configuration of remote hosts. 
Most are written assuming the remote server is a void linux musl/glibc base. (but easily adaptable to any distro)

## How to use a playbook:
Generally speaking, all playbooks are executed in the same fashion.  

First, define a remote host in the working directory of the playbook
```
echo 'SERVERS = void@server' > config.mk
```

Finally, run make
```
make
```

That's it.  
Drist will copy the files to the remote host, execute the script, and then return the results. Watch its progress in stdout.  
I've hackily added a function to drist to copy everything in /tmp/results* of the remote machine back to the working directory on the local machine. 


## Playbooks
### subfinder playbook
It performs subdomain enumeration on the target using subfinder. the results are stored and piped into shufledns/massdns to check resolution. The results are stored in /tmp and copied back to the local machine automatically upon completion.

### masscan playbook
It installs masscan to prepare for scanning a list of targets.
For parallel scanning with several void linux hosts, see my `deploy_masscan` script. 

---


In some cases, I want to automate the configuration AND deployment of instances, so I write some additional scripts, which are just wrappers around quik and the drist makefiles, to accomplish it.
An examples of the workflow is below:

- the enumerate_subdomains script uses [quik](https://github.com/wfnintr/quik) to deploy a void linux host and uses the subfinder playbook to install tooling and begin scanning a target. Results are then copied back to the local host, and then the deploy_masscan script is launched on the list of returned subdomains (actually, IP addresses after the list is piped to dnsprobe for resolving).

- the deploy_masscan script uses quik to deploy several void linux hosts and builds a masscan playbook to install the tooling and begin scanning the list of targets in parallel. The workload is divided between the instances to improve speed. Results are copied back to the local host working directory when finished. 








