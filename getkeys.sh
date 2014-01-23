#!/bin/bash

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
else
  REPO_DIR=$1
fi

EXTRACT_DIR=${REPO_DIR}/.gnupg
KEYURL=http://de.archive.ubuntu.com/ubuntu/pool/main/u/ubuntu-keyring
DEBPACKAGE=ubuntu-keyring_2012.05.19_all.deb
if [ ! -e ${EXTRACT_DIR} ]
then
  mkdir -p ${EXTRACT_DIR}
fi

pushd ${EXTRACT_DIR} > /dev/null
echo "get latest ubuntu keyring package..."
wget ${KEYURL}/${DEBPACKAGE}
echo "extract ubuntu debian package..."
dpkg-deb -x ${DEBPACKAGE} ./
gpg --no-default-keyring --keyring ./trustedkeys.gpg --import ./usr/share/keyrings/ubuntu-archive-keyring.gpg
popd > /dev/null
