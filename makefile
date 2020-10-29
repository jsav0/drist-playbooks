include config.mk

all: $(SERVERS)

$(SERVERS):
	drist -p -s $@

clean: 
	find . -name "config.*" -exec rm -f {} \;

ln:
	./.link.sh
