#!/usr/bin/env bash
# get base dir regardless of execution location
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCE=$([[ "$SOURCE" = /* ]] && echo "$SOURCE" || echo "$PWD/${SOURCE#./}")
basedir=$(dirname "$SOURCE")

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