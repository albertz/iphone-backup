olddir="$(pwd)"
cd "$(dirname "$0")"
mydir="$(pwd)"
cd "$olddir"

[ "$SSHRELAYDIR" = "" ] && SSHRELAYDIR="${mydir}/../iphone-ssh-relay"
[ "$IPHONEHOST" = "" ] && IPHONEHOST="iphone" # dummy for simplersync.py
[ "$RSYNCCMD" = "" ] && RSYNCCMD="${SSHRELAYDIR}/simplersync.py"
[ "$SSHCMD" = "" ] && SSHCMD="${SSHRELAYDIR}/simplessh.py -quiet"

function isync() {
	srcdir="$1"
	destdir="$2"

	$RSYNCCMD $IPHONEHOST:"$srcdir" "$destdir"
}

function issh() {
	${(z)SSHCMD} "${argv}"
}

function ils() {
	d="$1"

	issh "ls $d"
}
