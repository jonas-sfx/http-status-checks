#!/bin/sh

## filename      filter-xml4http200.sh
##
## description:  take a list of urls from a xml-sitemap-file (parameter 1)
##               and check their http-status-code
##               usage: ./filter-xml4http200.sh sitemap.xml
##               in the end you receive a sitemap.xml.200.xml
##               containing only the http-status-200 urls of that sitemap
##
## dependencies: xmlstarlet (sudo snap install xmlstarlet)
##
## author:       jonas@sfxonline.de
## =======================================================================

tmpfile=$(mktemp "$1".XXX.txt)
tmpxml=$(mktemp "$1".XXX.xml)

xmlstarlet sel -t -v '//*[local-name()="loc"]' "$1" | sed 's/ *//g' >  "$tmpfile"
cp "$1" "$1".200.xml

while read p; do
  status=""
  status=$(curl -s -o /dev/null -w "%{http_code}" "$p")

  if [ "$status" -eq 200 ]; then
    echo "[200 ✅] $p"
  else
    echo "[$status ⚡] $p"
    xml ed -d "//_:urlset/_:url[_:loc[(text()='$p')]]" $1.200.xml > $tmpxml
    mv $tmpxml $1.200.xml
    
  fi
done < "$tmpfile"

rm "$tmpfile"
