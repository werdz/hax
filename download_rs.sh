#!/bin/bash

# Rapidshare command line download script
# Requires wget
#
# ./download_rs.sh filelist.txt
#
# ...where filelist.txt contains a list of rapidshare URLs, separated by 
# newlines.
#
# all files will then be downloaded to the pwd. If required, it will ask you
# for your RS login details, and create a cookie file (`pwd`/rs-cookie).

COOKIEFILE=rs-cookie

if [ ! -f $COOKIEFILE ]; then 
	echo I need to login to rapidshare, no cookie found.
	read -p 'Enter Username: ' username
	
	# Horribly insecure, owell
	read -p 'Enter Password: ' password
	un=`echo $username|tr -d \\n`
	pw=`echo $password|tr -d \\n`
	
	echo "Username: ($un), Password: ($pw)"

	wget --no-check-certificate --save-cookies $COOKIEFILE --post-data "login=$un&password=$pw" -O - https://ssl.rapidshare.com/cgi-bin/premiumzone.cgi > /dev/null

fi

echo Downloading files listed in $1
cat $1 | while read filename; do
	echo Downloading $filename
	wget -c --load-cookies $COOKIEFILE $filename
done
echo Complete.

