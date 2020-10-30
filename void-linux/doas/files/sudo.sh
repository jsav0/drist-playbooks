#!/bin/sh

[ -z $1 ] && doas $SHELL || doas $@
