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

input_file="$1"
tmpfile=$(mktemp "$input_file.XXX.txt")

if xmlstarlet sel -t -m '//*[local-name()="loc" or local-name()="link"]' -v 'normalize-space(.)' "$input_file" | sed 's/ *//g' | sort -u > "$tmpfile"; then
  echo "$input_file is not a Sitemap-Index. I am fine with that."

  # write found urls in tmp-file
  xmlstarlet sel -t -v '//*[local-name()="loc" or local-name()="link"]' -v 'normalize-space(.)' "$input_file" | sed 's/ *//' | sort -u > "$tmpfile"

  while IFS= read -r p; do
    if [ -z "$p" ]; then
      continue
    fi
    status=$(curl -s -o /dev/null -w "%{http_code}" "$p")
    printf "[%s] %s\n" "$status" "$p"
  done < "$tmpfile"

  rm "$tmpfile"
else
  echo "$input_file is a Sitemap-Index. I need the Sitemap itself."
fi
