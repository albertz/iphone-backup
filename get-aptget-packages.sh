#!/bin/zsh

source common.sh

for l in ("${(@f)$(egrep "^Package:|^Priority:" ${backupdir}/var/lib/dpkg/status)"); do
	[[ "$l" =~ "^Package:" ]] && {
		echo $l	
	}
done

