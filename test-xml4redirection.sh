#!/bin/sh

## filename      test-xml4redirection.sh
##
## description:  take a list of urls from a xml-file (parameter 1)
##               and check their http-status-code
##               http-status-redirections are followed
##               usage: ./test-xml4redirection.sh sitemap.xml
##
## dependencies: xmlstarlet  (sudo snap install xmlstarlet)
##
## author:       jonas@sfxonline.de
## =======================================================================

tmpfile=$(mktemp "$1".XXX.txt)
xmlstarlet sel -t -v '//*[local-name()="loc"]' "$1" | sed 's/ *//g' >  "$tmpfile"
echo "" >> "$tmpfile"

while read p; do
  status=""
  status=$(curl -s -o /dev/null -w "%{http_code}" "$p")

  if [ "$status" -eq 200 ]; then
    echo "[200 ✅] $p"
  elif [ "$status" -eq 404 ]; then
    echo "[404 ❌] $p"
  elif [ "$status" -eq 500 ]; then
    echo "[500 ❌] $p"
  else
    echo -n "[$status ⚡] $p"
    loopstatus=$status
    location=$p
    while [ "$loopstatus" -eq 301 ] || [ "$loopstatus" -eq 302 ]; do
      location=$(curl -sI "$location" | grep "location:" | cut -d" " -f2 | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*")
      loopstatus=$(curl -s -o /dev/null -w "%{http_code}" $location)
      echo -n " > ["$loopstatus"] "$location
    done
    echo
  fi
done < "$tmpfile"

rm "$tmpfile"
