#!/bin/sh

# check if your system has all the required software installed
# like: debmirror, rsync, wget, ...

return_value=0
# add additional programm here
LISTING="debmirror rsync wget"


# take a listing and check if the porgramm exists
checker()
{
  for prog in ${LISTING}
  do
    if which ${prog} >/dev/null; then
      echo "${prog}\t\tOK"
    else
      echo "${prog}\t\tmissing!!!"
      return_value=1
  fi
  done
}
checker
exit ${return_value}
