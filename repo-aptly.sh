#!/bin/sh

# depends on aptly (http://aptly.info)

url=de.archive.ubuntu.com/ubuntu
arch="i386,amd64"
section="main restricted universe multiverse"
releases="precise precise-security precise-updates precise-backports"
# create new precise repositories
for release in ${releases}
do
  echo "aptly -architectures="${arch}"  mirror create ${release} ${protocol}${url} ${release} ${section}"
  aptly -architectures="${arch}"  mirror create ${release} ${protocol}${url} ${release} ${section}
done
# update all precise repositories
aptly mirror list | sed -e 's#.*\[\(.*\)\]:.*#\1#g' | grep -E 'precise.*' | xargs -n 1 aptly mirror update
