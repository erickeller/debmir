debmir
======

some useful script to automate Ubuntu selective mirroring.

Install
=======

git clone https://github.com/erickeller/debmir.git

Description
===========

* getkeys.sh /dir/to/repo: get the ubuntu keys extract them and import these locally, preventing to modify user ~/.gnupg keys.

* update-repo.sh: perform a selective repository mirror. Currently hard coded into the script. 

Instructions
============

./getkeys.sh .
./update-repo.sh



