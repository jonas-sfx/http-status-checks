#!/bin/bash

## filename     test-txt4validurl.sh
##
## description: take a list of urls from a textfile (parameter 1)
##              and syntax clidity
##              usage: ./test-txt4validurl.sh myurls.txt
##              (url-textfile should end with a newline)
##
## author:      jonas@sfxonline.de
## =======================================================================

regex='^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'

while read p; do
  if [[ "$p" =~ $regex ]]
  then
      status="✅"
  else
      status="❌"
  fi
  echo -n "["
  echo -n "$status"
  echo -n "] "
  echo -n "\"$p\""
  echo ""
done < "$1"
