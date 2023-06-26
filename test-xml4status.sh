#!/bin/sh

## filename      test-xml4status.sh
##
## description:  take a list of urls from a xml-sitemap-file (parameter 1)
##               and check their http-status-code
##               usage: ./test-xml4status.sh sitemap.xml
##
## dependencies: xmlstarlet (sudo snap install xmlstarlet)
##
## author:       jonas@sfxonline.de
## =======================================================================

tmpfile=$(mktemp "$1".XXX.txt)
xmlstarlet sel -t -v '//*[local-name()="loc"]' "$1" | sed 's/ *//g' >  "$tmpfile"
echo "" >> "$tmpfile"

while read p; do
  status=""
  status=$(curl -s -o /dev/null -w "%{http_code}" "$p")
  echo -n "["
  echo -n "$status"
  echo -n "] "
  echo -n "$p"
  echo ""
done < "$tmpfile"

rm "$tmpfile"
