# darkvoid playbook
provisions a void linux host for recon and offensive hacking  

## Basic usage
1. define target in config.mk
2. run make
3. that's it

# Example
```
echo 'SERVERS = void@67.205.155.81' > config.mk && make
```

--- 

1. define target server(s) in config.mk
```
echo 'SERVERS = user@server1 user@server2 user@server3' > config.mk
```

2. execute make
```	
make
```

3. that's it.

---

this mimicks my ansible darkvoid playbook, but drist is more simple, seriously.  
