#!/bin/sh

## filename      beautify-xml.sh
##
## description:  beautify an xmlfile
##
## dependencies: xmlstarlet  (sudo snap install xmlstarlet)
##
## =======================================================================

xml format $1 > $2