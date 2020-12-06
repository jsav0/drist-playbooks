#!/bin/sh

./enumerate_subdomains.sh $1 && cd masscan && make
