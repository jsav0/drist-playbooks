#!/bin/sh

tmux ls | grep "^irc" && {
        tmux a -t irc
} || {
        tmux new-session -s irc weechat
}
