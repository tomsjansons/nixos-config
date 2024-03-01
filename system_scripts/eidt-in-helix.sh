#!/bin/bash

# $1 = relative file path
# $2 = session name

tabName="Helix"
sessionName="Helix"

if test -z "$1"
then
  echo "File name not provided"
  exit 1
fi

fileName=$(readlink -f $1) # full path to file

if ! test -z "$2"
then
  sessionName="$2"
fi

if ! pgrep -x hx > /dev/null
then
  zellij -s "$sessionName" action go-to-tab-name $tabName --create
  sleep 0.5
  zellij -s "$sessionName" action write-chars "hx"
  sleep 0.5
  zellij -s "$sessionName" action write 13 # send enter-key
  sleep 0.5
fi

zellij -s "$sessionName" action go-to-tab-name $tabName --create

zellij -s "$sessionName" action write 27 # send escape-key
zellij -s "$sessionName" action write-chars ":open $fileName"
zellij -s "$sessionName" action write 13 # send enter-key
