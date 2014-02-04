#!/bin/bash
# this script does use rsync to make a backup

usage()
{
  echo "
usage: $0 from to

example:
$0 /repo /repo_backup
"
exit 1
}


if [ "$#" -ne 2 ]
then
  usage
fi

RSYNC_OPTION="--verbose --checksum --recursive --links --hard-links --delete --perms --executability --group --times --compress --progress"
FROM=$1
TO=$2
echo "rsync from: ${FROM} to: ${TO}
Using options: ${RSYNC_OPTION}"

rsync ${RSYNC_OPTION} ${FROM} ${TO}

