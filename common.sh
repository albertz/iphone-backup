olddir="$(pwd)"
cd "$(dirname "$0")"
mydir="$(pwd)"
cd "$olddir"

[ "$SSHRELAYDIR" = "" ] && SSHRELAYDIR="${mydir}/../iphone-ssh-relay"
[ "$RSYNCCMD" = "" ] && RSYNCCMD="${SSHRELAYDIR}/simplersync.py"
[ "$RSYNCHOST" = "" ] && RSYNCHOST="iphone" # dummy for simplersync.py
