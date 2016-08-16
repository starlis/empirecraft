#!/usr/bin/env bash
. scripts/init.sh

if [ ! -d "${FORK_NAME}-API" ]; then
git clone $API_REPO ${FORK_NAME}-API
fi

if [ ! -d "${FORK_NAME}-Server" ]; then
git clone $SERVER_REPO ${FORK_NAME}-Server
fi

cd ${FORK_NAME}-API
git fetch origin
git reset --hard origin/master

cd ..

cd ${FORK_NAME}-Server
git fetch origin
git reset --hard origin/master

cd ..
if [ "$1" != "--nocompile" ]; then
	mvn clean install
fi