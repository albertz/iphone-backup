olddir="$(pwd)"
cd "$(dirname "$0")"
mydir="$(pwd)"
cd "$olddir"

[ -e ~/Documents/iphone-access-info.sh ] && source ~/Documents/iphone-access-info.sh

[ "$SSHRELAYDIR" = "" ] && SSHRELAYDIR="${mydir}/../iphone-ssh-relay"
if [ "$HOST" != "" ]; then # small shortcut
	[ "$RSYNCCMD" = "" ] && [ "$PORT" != "" ] && RSYNCCMD="rsync -avP -e \"ssh -p $PORT\""
	[ "$SSHCMD" = "" ] && [ "$PORT" != "" ] && SSHCMD="ssh root@$HOST -p $PORT"
	[ "$RSYNCCMD" = "" ] && RSYNCCMD="rsync -avP"
	[ "$SSHCMD" = "" ] && SSHCMD="ssh root@$HOST"
fi
[ "$HOST" = "" ] && HOST="iphone" # dummy for simplersync.py
[ "$RSYNCCMD" = "" ] && RSYNCCMD="${SSHRELAYDIR}/simplersync.py"
[ "$SSHCMD" = "" ] && SSHCMD="${SSHRELAYDIR}/simplessh.py -quiet"

function isync() {
	srcdir="$1"
	destdir="$2"

	${(Q)${(z)RSYNCCMD}} --exclude private_key \
		root@$HOST:"\"$srcdir\"" "$destdir"
}

function issh() {
	${(Q)${(z)SSHCMD}} "\"${argv}\""
}

function ils() {
	d="$1"

	issh "ls $d"
}
