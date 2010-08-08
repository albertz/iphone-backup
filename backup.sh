#!/bin/zsh

source common.sh

if [ "$1" = "" ]; then
	echo "usage: $0 <local-backup-dir>"
	exit 1
fi

backupdir="$1"

if [ \! -d "$backupdir" ]; then
	echo "error: $backupdir does not exist or is not a directory"
	exit 1
fi

echo -n "* reading /Applications"

# this will grab all apps which were copied manually into /Applications
# i.e. non-Apple and not installed via Cydia/apt-get
issh " \
	cd /Applications; \
	for d in *; do \
		[ \! -d \"\$d\" ] && continue; \
		grep com.apple. \"\$d/Info.plist\" >/dev/null 2>/dev/null && continue; \
		dpkg -S \"\$d\" >/dev/null && continue; \
		echo \"\$d\"; \
	done; \
	" | \
{ while read a; do iapps+=($a); done }
iapps=(/Applications/$^iapps[@])
echo " ."

echo -n "* reading /var/mobile"
homedirs=(${(f)"$(ils /var/mobile)"}) # * in ~
homedirs=("${(@)homedirs:#Applications}") # remove the App dir
homedirs=(/var/mobile/$^homedirs[@])
echo " ."

echo -n "* reading /etc"
etcdirs=(${(f)"$(ils /etc/)"})
etcdirs=(/etc/$^etcdirs[@])
echo " ."

dirs=($iapps $homedirs $etcdirs)
echo $dirs
