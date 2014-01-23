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

KEYERING_DIR=${REPO_DIR}/.gnupg
KEYURL=http://de.archive.ubuntu.com/ubuntu/pool/main/u/ubuntu-keyring
DEBPACKAGE=ubuntu-keyring_2012.05.19_all.deb
if [ ! -e ${KEYERING_DIR} ]
then
  mkdir -p ${KEYERING_DIR}
fi

# do not get the keys if ${REPO_DIR}/.keys_dir exists
if [ -e ${REPO_DIR}/.keys_dir ]
then
  echo "a ${REPO_DIR}/.keys_dir exists, delete this file in order to grab the keys again:
rm -f ${REPO_DIR}/.keys_dir"
exit 2
fi

pushd ${KEYERING_DIR} > /dev/null
echo "get latest ubuntu keyring package..."
wget ${KEYURL}/${DEBPACKAGE}
echo "extract ubuntu debian package..."
dpkg-deb -x ${DEBPACKAGE} ./
gpg --no-default-keyring --keyring ./trustedkeys.gpg --import ./usr/share/keyrings/ubuntu-archive-keyring.gpg
popd > /dev/null

echo "store keyering location to ${REPO_DIR}/.keys_dir ..."
echo "${KEYERING_DIR}" > ${REPO_DIR}/.keys_dir
