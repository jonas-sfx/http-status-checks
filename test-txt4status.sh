#!/bin/sh

## filename     test-txt4status.sh
##
## description: take a list of urls from a textfile (parameter 1)
##              and check their http-status-code
##              usage: ./test-txt4status.sh myurls.txt
##              (url-textfile should end with a newline)
##
## author:      jonas@sfxonline.de
## =======================================================================

while read p; do
  status=""
  status=$(curl -s -o /dev/null -w "%{http_code}" $p)
  echo -n "["
  echo -n $status
  echo -n "] "
  echo -n "$p"
  echo ""
done < $1
