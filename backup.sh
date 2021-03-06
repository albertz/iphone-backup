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
		dpkg -S \"\$d\" >/dev/null 2>/dev/null && continue; \
		echo \"\$d\"; \
	done; \
	" | \
{ while read a; do iapps+=($a); done } || exit 1
iapps=(/Applications/$^iapps[@])
echo " ."

echo -n "* reading /var/mobile"
homedirs=(${(f)"$(ils /var/mobile)"}) || exit 1 # * in ~
homedirs=("${(@)homedirs:#Applications}") # remove the App dir, we dont want them
homedirs=("${(@)homedirs:#Media}") # remove the Media dir, we handle this separately
homedirs=(/var/mobile/$^homedirs[@])
echo " ."

echo -n "* reading /var/mobile/Media"
mediadirs=(${(f)"$(ils /var/mobile/Media)"}) || exit 1
mediadirs=("${(@)mediadirs:#iTunes_Control}") # remove iTunes data (mp3s and co)
mediadirs=("${(@)mediadirs:#myTunes}") # remove myTunes (hardlinks to iTunes mp3s)
mediadirs=(/var/mobile/Media/$^mediadirs[@])
echo " ."

echo -n "* reading /etc"
etcdirs=(${(f)"$(ils /etc/)"}) || exit 1
etcdirs=(/etc/$^etcdirs[@])
echo " ."

dirs=($iapps $homedirs $mediadirs $etcdirs /var/lib /var/preferences /.trackme)

# remove some
# DCIM, i.e. Pictures/Videos should maybe be handled separately. At least I do that.
dirs=("${(@)dirs:#/var/mobile/Media/DCIM}")
# Purchases might be huge and is anyway covered by the Apple system.
dirs=("${(@)dirs:#/var/mobile/Media/Purchases}")

echo "dirs:"
echo $dirs

for d in $dirs; do
	echo "* syncing $d ..."
	dest="${backupdir}/$(dirname $d)"
	mkdir -p $dest
	# sometimes I get bad-file-descriptors errors, e.g.:
	# /var/mobile/Library/Mobile Documents/com~apple~mail/Data/MailData/Signatures/ubiquitous_AllSignatures.plist: Bad file descriptor
	# but might not be important, so ignore and continue
	isync $d $dest
done

echo "*** done"
