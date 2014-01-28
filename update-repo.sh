#### Start script to automate building of Ubuntu mirror #####
## THE NEXT LINE IS NEEDED THE REST OF THE LINES STARTING WITH A # CAN BE DELETED

#!/bin/bash

## Setting variables with explanations.
SCRIPT_DIR=$(readlink -f ${0%/*})
usage()
{
  echo "usage: $0 dir/to/repo
  example:
  $0 /media/repos
  $0 ./
  "
    exit 1
}

if [ $# -ne 1 ]
then
  usage
fi

# Outpath=              # Directory to store the mirror in
# Make this a full path to where you want to mirror the material.
#
outPath=$1

#
# create local keys
#
${SCRIPT_DIR}/getkeys.sh ${outPath}

#
# Don't touch the user's keyring, have our own instead
#
LOCAL_KEYS_DIR=`readlink -f ${outPath}/.gnupg`
#
# checkout debmirror keyring capabilities
#
man debmirror | grep "keyring=file" 2>&1 > /dev/null
if [ $? -eq 0 ]
then
  LOCAL_KEY=${LOCAL_KEYS_DIR}/usr/share/keyrings/ubuntu-archive-keyring.gpg
  echo "using keyring option with ${LOCAL_KEY}"
  KEY_OPTION="--keyring ${LOCAL_KEY}"
else
  echo "exporting GNUPGHOME=${LOCAL_KEYS_DIR}"
  export GNUPGHOME=${LOCAL_KEYS_DIR}
  KEY_OPTION=""
fi
echo "$KEY_OPTION"
# Arch=         -a      # Architecture. For Ubuntu can be i386, powerpc or amd64.
# sparc, only starts in dapper, it is only the later models of sparc.
#
arch=i386,amd64

# Minimum Ubuntu system requires main, restricted
# Section=      -s      # Section (One of the following - main/restricted/universe/multiverse).
# You can add extra file with $Section/debian-installer. ex: main/debian-installer,universe/debian-installer,multiverse/debian-installer,restricted/debian-installer
#
section=main,restricted,universe,multiverse

# Release=      -d      # Release of the system (Dapper, Edgy, Feisty, Gutsy, Hardy, Intrepid), and the -updates and -security ( -backports can be added if desired)
#
release=precise,precise-security,precise-updates,precise-backports

# Server=       -h      # Server name, minus the protocol and the path at the end
# CHANGE "*" to equal the mirror you want to create your mirror from. au. in Australia  ca. in Canada.
# This can be found in your own /etc/apt/sources.list file, assuming you have Ubuntu installed.
#
server=de.archive.ubuntu.com

# Dir=          -r      # Path from the main server, so http://my.web.server/$dir, Server dependant
#
inPath=/ubuntu

# Proto=        -e      # Protocol to use for transfer (http, ftp, hftp, rsync)
# Choose one - http is most usual the service, and the service must be avaialbe on the server you point at.
#
proto=http


# The --nosource option only downloads debs and not deb-src's
# The --progress option shows files as they are downloaded
# --source \ in the place of --no-source \ if you want sources also.
# --nocleanup  Do not clean up the local mirror after mirroring is complete. Use this option to keep older repository
# Start script
#
debmirror       -a $arch \
                --source \
                --md5sums \
                --progress \
                --passive \
                -s $section \
                -h $server \
                -d $release \
                -r $inPath \
                ${KEY_OPTION} \
                -e $proto \
                $outPath

#### End script to automate building of Ubuntu mirror ####
