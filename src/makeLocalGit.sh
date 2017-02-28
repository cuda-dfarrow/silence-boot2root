#!/usr/bin/env bash

if [ "$USER" != "psimon" ]; then
	echo "This script must be run as 'psimon'"
	exit -1
fi

ssh-keyscan -H localhost >> ~/.ssh/known_hosts

cd ~/silence-webapp
git config --global user.name "Paul Simon"
git config --global user.email "psimon@bnsec.com"
git init
git add .
git commit -m "initial commit"
git remote add origin git@localhost:/home/git/silence-webapp.git
git push origin master

cd
rm -rf ./silence-webapp
