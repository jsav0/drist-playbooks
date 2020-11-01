# drist-playbooks
scripts for configuring remote servers

## Usage:
### Deploying a playbook
```
cd <playbook>
drist void@server
``

### Deploying a playbook with make
```
cd <playbook>
ln -s ../../makefile
echo 'SERVERS = user@server1 user@server2 user@server3' > config.mk
make
```

### Writing a new playbook
```
mkdir <playbook> && cd <playbook>
mkdir files && printf 'this is a file\n' > files/file
printf '#!/bin/sh\ncat file && echo this is a script\n' > script
```

---

## How to parallelize:
```
make -j 3 # tell make to use 3 threads
```

