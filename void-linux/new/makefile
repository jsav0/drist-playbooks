include config.mk

all: $(SERVERS)

$(SERVERS):
	drist -p -s $@

clean: 
	find . -name "config.mk" -exec rm -f {} \;
